package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"
)

func migrateCmd(args []string) {
	fs := flag.NewFlagSet("migrate", flag.ExitOnError)
	dataDir := fs.String("data-dir", "/opt/viewtouchf", "data dir")
	daemon := fs.String("daemon", "build/vt_daemon", "path to vt_daemon binary")
	timeout := fs.Duration("timeout", 30*time.Second, "max wait for migrations/listen")
	fs.Parse(args)

	cmd := exec.Command(*daemon, "--data-dir", *dataDir)
	stdout, _ := cmd.StdoutPipe()
	stderr, _ := cmd.StderrPipe()

	if err := cmd.Start(); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to start daemon: %v\n", err)
		os.Exit(1)
	}

	ready := make(chan struct{}, 1)

	go func() {
		s := bufio.NewScanner(stdout)
		for s.Scan() {
			line := s.Text()
			fmt.Println(line)
			if strings.Contains(line, "listening on unix://") {
				ready <- struct{}{}
				return
			}
		}
	}()
	go func() {
		s := bufio.NewScanner(stderr)
		for s.Scan() {
			line := s.Text()
			fmt.Fprintln(os.Stderr, line)
			if strings.Contains(line, "listening on unix://") {
				ready <- struct{}{}
				return
			}
		}
	}()

	select {
	case <-ready:
		fmt.Println("Migrations applied / daemon listening — stopping daemon.")
		_ = cmd.Process.Signal(os.Interrupt)
		_ = cmd.Wait()
	case <-time.After(*timeout):
		fmt.Fprintln(os.Stderr, "Timeout waiting for daemon to listen; terminating")
		_ = cmd.Process.Kill()
		_ = cmd.Wait()
		os.Exit(2)
	}
}
