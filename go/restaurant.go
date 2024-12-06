package main

import (
	"log"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
)

// A little utility that simulates performing a task for a random duration.
// For example, calling do(10, "Remy", "is cooking") will compute a random
// number of milliseconds between 5000 and 10000, log "Remy is cooking",
// and sleep the current goroutine for that much time.

func do(seconds int, action ...any) {
	log.Println(action...)
	randomMillis := 500*seconds + rand.Intn(500*seconds)
	time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

// Order represents a meal order placed by a customer.
type Order struct {
	id         uint64
	customer   string
	reply      chan *Order
	preparedBy string
}

// thread-safe counter used to assign unique IDs to orders
var orderID atomic.Uint64

// representing the waiter who can hold up to 3 outstanding orders
var waiter = make(chan *Order, 3)

// cook takes an order from the waiter then send the completed order back when cooked
func cook(name string) {
	log.Println(name, "starting work")
	for {
		order := <-waiter
		do(10, name, "cooking order", order.id, "for", order.customer)
		order.preparedBy = name
		order.reply <- order
	}
}

// Customer places orders, eats meals, leaves after 5 meals
func customer(name string, wg *sync.WaitGroup) {
	defer wg.Done()
	mealsEaten := 0

	for mealsEaten < 5 {
		order := &Order{
			id:       orderID.Add(1),
			customer: name,
			reply:    make(chan *Order),
		}
		log.Println(name, "placed order", order.id)

		select {
		case waiter <- order:
			meal := <-order.reply
			do(2, name, "eating cooked order", meal.id, "prepared by", meal.preparedBy)
			mealsEaten++
		case <-time.After(7 * time.Second):
			do(5, name, "waiting too long, abandoning order", order.id)
		}
	}
	log.Println(name, "going home")
}

// Sets up cooks and customers, starts simulation
func main() {
	rand.Seed(time.Now().UnixNano())
	log.Println("Restaurant opening")

	customers := []string{"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai"}
	cooks := []string{"Remy", "Colette", "Linguini"}

	var wg sync.WaitGroup

	// Start cooks
	for _, name := range cooks {
		go cook(name)
	}

	// Start customers
	for _, name := range customers {
		wg.Add(1)
		go customer(name, &wg)
	}

	wg.Wait() // Wait for all customers to finish eating
	log.Println("Restaurant closing")
}
