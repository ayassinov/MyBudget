package routes

import "github.com/gorilla/mux"

const (
	//ListCategories is the route name for listing all categories
	ListCategories = "ListCategories"

	//CreateCategory is the route name for create new category
	CreateCategory = "CreateCategory"

	//GetCategory is the route name for getting a category
	GetCategory = "GetCategory"
)

//API define the routes for the rest api endpoints to be called by the clients.
func API() *mux.Router {
	//we can use "Accept", "text/json" to handle only json accepted requests
	m := mux.NewRouter()
	m.Path("/category").Methods("GET").Name(ListCategories)
	m.Path("/category").Methods("POST").Name(CreateCategory)
	m.Path("/category/{ID:.+}").Methods("GET").Name(GetCategory)
	//add here you next api end point
	return m
}
