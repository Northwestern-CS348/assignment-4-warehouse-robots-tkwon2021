(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
   		:parameters (?r - robot ?l1 - location ?l2 - location)
		:precondition (and (connected ?l1 ?l2) (connected ?l2 ?l1) (no-robot ?l2) (at ?r ?l1))
		:effect (and (at ?r ?l2) (not (no-robot ?l2)) (no-robot ?l1) (not (at ?r ?l1)))
   )

   (:action robotMoveWithPallette
   		:parameters (?r - robot ?l1 - location ?pack - location ?p - pallette)
		:precondition (and (connected ?l1 ?pack) (connected ?pack ?l1) (no-robot ?pack) (no-pallette ?pack) (at ?r ?l1) (at ?p ?l1))
		:effect (and (not (no-pallette ?pack)) (not (no-robot ?pack)) (at ?r ?pack) (at ?p ?pack) (no-robot ?l1) (no-pallette ?l1) (not (at ?r ?l1)) (not (at ?p ?l1)))
   )

   (:action moveItemFromPalletteToShipment
   		:parameters (?l - location ?ship - shipment ?item - saleitem ?p - pallette ?o - order)
		:precondition (and (at ?p ?l) (contains ?p ?item) (orders ?o ?item) (started ?ship) (packing-at ?ship ?l))
		:effect (and (includes ?ship ?item) (not (contains ?p ?item)))
	)

	(:action completeShipment
		:parameters (?s - shipment ?o - order ?l - location)
		:precondition (and (started ?s) (ships ?s ?o) (packing-location ?l) (packing-at ?s ?l))
		:effect (and (not (started ?s)) (complete ?s) (available ?l) (not (packing-at ?s ?l)))
	)

)
