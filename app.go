package main

import (
    "fmt"
    "net/http"
    "time"
)

func main() {
        fmt.Printf("Autor: Michał Kryk \n")
        fmt.Printf("Data uruchomienia: %s\n", time.Now().UTC().Add(2*time.Hour).Format(time.RFC3339))
        fmt.Printf("Serwer nasłuchuje na porcie: 8080\n")


    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        clientIP := r.RemoteAddr

        fmt.Fprintf(w, "<h1>Informacje o adresie IP klienta</h1>")
        fmt.Fprintf(w, "<p>Adres IP klienta: %s</p>", clientIP)
        fmt.Fprintf(w, "<p>Data i godzina: %s</p>", time.Now().UTC().Add(2*time.Hour).Format("02-01-2006 15:04:05"))
    })

    http.ListenAndServe(":8080", nil)
}