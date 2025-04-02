(define (domain blocksworld)

; Versió relaxada del blocksworld sense efectes negatius


  (:requirements :strips :typing :equality)
  (:types block)
  (:predicates (on ?x ?y - block) (ontable ?x - block) 
        (clear ?x - block) (handempty) (holding ?x - block))
        
  (:action pick-up
   :parameters (?x - block)
   :precondition (and (clear ?x) (ontable ?x) (handempty))
   :effect (and   (holding ?x)))

  (:action put-down
   :parameters (?x - block)
   :precondition (holding ?x)
   :effect (and  (clear ?x)
                (handempty) (ontable ?x)))

  (:action stack
   :parameters (?x ?y - block)
   :precondition (and (holding ?x) (clear ?y) (not (= ?x ?y)))
   :effect (and  (clear ?x)
                (handempty) (on ?x ?y)))
                
  (:action unstack
   :parameters (?x ?y - block)
   :precondition (and (on ?x ?y) (clear ?x) (handempty) 
                 )
   :effect (and (holding ?x) (clear ?y) ))
)