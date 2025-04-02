(define (problem p1)
  (:domain blocksworld)

  (:objects
   a b c d - block)

  (:init

  (ontable a)
  (ontable b)
  (ontable c)
  (on d c)
  (clear a)
  (clear b)
  (clear d)
  (handempty)
  )

  (:goal (and
    (ontable d)
    (ontable c)
    (on a b)
    (on b d)
    (clear a)
    (clear c)
  )
  )
)
