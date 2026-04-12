package main

import (
    "bufio"
    "flag"
    "fmt"
    "os"
    "os/exec"
    "path/filepath"
    "strings"
    "syscall"
    "time"
)

func seedCmd(args []string) {
    fs := flag.NewFlagSet("seed-demo", flag.ExitOnError)
    dataDir := fs.String("data-dir", "/opt/viewtouchf", "data dir (default: /opt/viewtouchf)")
    daemon := fs.String("daemon", "build/vt_daemon", "path to vt_daemon binary")
    keep := fs.Bool("keep", false, "keep daemon running after seeding")
    timeout := fs.Duration("timeout", 30*time.Second, "max wait for seeding")
    fs.Parse(args)

    dbPath := filepath.Join(*dataDir, "data", "viewtouchf.db")
    if _, err := os.Stat(dbPath); err == nil {
        backup := dbPath + ".bak." + time.Now().Format("20060102T150405")
        fmt.Printf("Backing up existing DB to %s\n", backup)
        if err := os.Rename(dbPath, backup); err != nil {
            fmt.Fprintf(os.Stderr, "Failed to backup DB: %v\n", err)
            os.Exit(1)
        }
    } else {
        fmt.Printf("No existing DB found at %s, proceeding\n", dbPath)
    }

    cmd := exec.Command(*daemon, "--data-dir", *dataDir)
    stdout, _ := cmd.StdoutPipe()
    stderr, _ := cmd.StderrPipe()

    if err := cmd.Start(); err != nil {
        fmt.Fprintf(os.Stderr, "Failed to start daemon: %v\n", err)
        os.Exit(1)
    }

    found := make(chan string, 1)

    go func() {
        s := bufio.NewScanner(stdout)
        for s.Scan() {
            line := s.Text()
            fmt.Println(line)
            if strings.Contains(line, "seeded demo menu") {
                found <- line
                return
            }
        }
    }()
    go func() {
        s := bufio.NewScanner(stderr)
        for s.Scan() {
            line := s.Text()
            fmt.Fprintln(os.Stderr, line)
            if strings.Contains(line, "seeded demo menu") {
                found <- line
                return
            }
        }
    }()

    select {
    case l := <-found:
        fmt.Printf("Seed successful: %s\n", l)
        if !*keep {
            _ = cmd.Process.Signal(syscall.SIGTERM)
            _ = cmd.Wait()
        }
    case <-time.After(*timeout):
        fmt.Fprintln(os.Stderr, "Timeout waiting for seed message; terminating daemon")
        _ = cmd.Process.Kill()
        _ = cmd.Wait()
        os.Exit(2)
    }
}
