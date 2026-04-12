package main

import (
	"fmt"
	"os"
)

func usage() {
	fmt.Print(`vtctl — ViewTouchF control CLI

Usage:
  vtctl <command> [flags]

Commands:
  status      Check daemon socket
  seed-demo   Seed demo menu by starting daemon
  migrate     Run DB migrations (start daemon until ready)
  backup      Backup the SQLite DB
  restore     Restore the SQLite DB from a backup
  serve       Run the daemon in foreground
  help        Show this help
`)
}

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(1)
	}
	cmd := os.Args[1]
	args := os.Args[2:]

	switch cmd {
	case "status":
		statusCmd(args)
	case "seed-demo":
		seedCmd(args)
	case "migrate":
		migrateCmd(args)
	case "backup":
		backupCmd(args)
	case "restore":
		restoreCmd(args)
	case "serve":
		serveCmd(args)
	case "help":
		usage()
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n\n", cmd)
		usage()
		os.Exit(2)
	}
}
