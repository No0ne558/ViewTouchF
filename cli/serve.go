package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
)

func serveCmd(args []string) {
	fs := flag.NewFlagSet("serve", flag.ExitOnError)
	dataDir := fs.String("data-dir", "/opt/viewtouchf", "data dir")
	daemon := fs.String("daemon", "build/vt_daemon", "path to vt_daemon binary")
	fs.Parse(args)

	cmd := exec.Command(*daemon, "--data-dir", *dataDir)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	if err := cmd.Start(); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to start daemon: %v\n", err)
		os.Exit(1)
	}

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	<-sigs
	_ = cmd.Process.Signal(syscall.SIGTERM)
	_ = cmd.Wait()
}
