package main

import (
	"flag"
	"fmt"
	"net"
	"os"
	"time"
)

func statusCmd(args []string) {
	fs := flag.NewFlagSet("status", flag.ExitOnError)
	sock := fs.String("socket", "/opt/viewtouchf/run/pos.sock", "path to unix domain socket")
	timeout := fs.Duration("timeout", time.Second, "dial timeout")
	fs.Parse(args)

	if _, err := os.Stat(*sock); err != nil {
		if os.IsNotExist(err) {
			fmt.Printf("Socket does not exist: %s\n", *sock)
		} else {
			fmt.Printf("Stat error: %v\n", err)
		}
	} else {
		fmt.Printf("Socket exists: %s\n", *sock)
	}

	conn, err := net.DialTimeout("unix", *sock, *timeout)
	if err != nil {
		fmt.Printf("Daemon not reachable: %v\n", err)
		os.Exit(1)
	}
	_ = conn.Close()
	fmt.Println("Daemon reachable (connected).")
}
