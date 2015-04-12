package datastore

// Plan hold the budgets and accounts of a user
type Plan struct {
	ID          int64
	name        string
	description *string
	balance     float32
}

//UserPlan relation between a user and a plan
type UserPlan struct {
	UserID int64
	PlanID int64
	Plan
	User
}
