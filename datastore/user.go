package datastore

//User of the application
type User struct {
	ID        int64
	UID       string
	FisrtName string
	LastName  string
	URLImage  string
	Email     string
	Password  string
	NetWorth  float32
}
