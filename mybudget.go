package main

import (
	"net/http"

	"github.com/codegangsta/negroni"
	"github.com/parisianninjas/mybudget/handlers"
)

func main() {
	m := http.NewServeMux()
	m.Handle("/api/", http.StripPrefix("/api", handlers.HandleAPI()))

	n := negroni.Classic()
	n.UseHandler(m)
	n.Run(":8000")
}
