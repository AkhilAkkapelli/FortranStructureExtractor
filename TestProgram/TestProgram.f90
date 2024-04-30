module m1
  implicit none

  contains

  subroutine m1s1()
    print*, "m1s1"
  end subroutine m1s1

  subroutine m1s2()
    print*, "m1s2"
  end subroutine m1s2

end module m1

module m2
  implicit none

  interface
    function m2if1()
    end function m2if1

    function m2if2()
    end function m2if2
  end interface

end module m2

module m3
  implicit none

  contains

  function m1f1()
    print*, "m1f1"
  end function m1f1

end module m3

subroutine s1()
  print*, "s1"
end subroutine s1

program mp
  use m1
  implicit none

  interface
    function mpif1()
    end function mpif1

    subroutine mpis1()
    end subroutine mpis1
  end interface 

  integer :: i

  i = 1

  call s1()

  contains

  subroutine mps1()
    print*, "mps1"
  end subroutine mps1

  subroutine mps1s1()
    print*, "mps1s1"
  end subroutine mps1s1

end program mp
