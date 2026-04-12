package main

import (
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
)

func copyFile(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	if err := os.MkdirAll(filepath.Dir(dst), 0o755); err != nil {
		return err
	}
	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()
	if _, err := io.Copy(out, in); err != nil {
		return err
	}
	return out.Sync()
}

func backupCmd(args []string) {
	fs := flag.NewFlagSet("backup", flag.ExitOnError)
	dataDir := fs.String("data-dir", "/opt/viewtouchf", "data dir")
	outPath := fs.String("out", "", "backup destination path (required)")
	fs.Parse(args)
	if *outPath == "" {
		fmt.Fprintln(os.Stderr, "--out is required")
		fs.Usage()
		os.Exit(2)
	}
	dbPath := filepath.Join(*dataDir, "data", "viewtouchf.db")
	if err := copyFile(dbPath, *outPath); err != nil {
		fmt.Fprintf(os.Stderr, "backup failed: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("Backup written to %s\n", *outPath)
}

func restoreCmd(args []string) {
	fs := flag.NewFlagSet("restore", flag.ExitOnError)
	dataDir := fs.String("data-dir", "/opt/viewtouchf", "data dir")
	inPath := fs.String("in", "", "backup source path (required)")
	fs.Parse(args)
	if *inPath == "" {
		fmt.Fprintln(os.Stderr, "--in is required")
		fs.Usage()
		os.Exit(2)
	}
	dbPath := filepath.Join(*dataDir, "data", "viewtouchf.db")
	if err := copyFile(*inPath, dbPath); err != nil {
		fmt.Fprintf(os.Stderr, "restore failed: %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("Restored DB from %s\n", *inPath)
}
