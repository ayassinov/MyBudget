package handlers

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"github.com/parisianninjas/mybudget/routes"
)

//HandleAPI define handlers for api
func HandleAPI() *mux.Router {
	m := routes.API()
	m.Get(routes.GetCategory).Handler(handler(handleGetCategory))
	m.Get(routes.ListCategories).Handler(handler(handleListCategory))
	m.Get(routes.CreateCategory).Handler(handler(handleCreateCategory))
	return m
}

type handler func(http.ResponseWriter, *http.Request) error

func (h handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	err := h(w, r)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "error: %s", err)
		log.Println(err)
	}
}

func handleGetCategory(w http.ResponseWriter, r *http.Request) error {
	id, err := strconv.Atoi(mux.Vars(r)["ID"])
	if err != nil {
		return err
	}

	return writeJSON(w, id)
}

func handleListCategory(w http.ResponseWriter, r *http.Request) error {
	return writeJSON(w, "Welcome to list of all categories :) ")
}

func handleCreateCategory(w http.ResponseWriter, r *http.Request) error {
	return writeJSON(w, "Welcome to the creation of the new category :)!")
}
