C     OBSERVABLES
C     0!
C     Lluís Torres 
C     TFM
C     FORTRAN 95

      PROGRAM OBSERVABLES

      USE MODEL

C-----(SYSTEM)------------------------------------------------
C     NODES, EDGES, CONNECTIVITY
      INTEGER N, z
C     TROTTER INDEX
      INTEGER R
C     +1 -1 EDGES RATIO (1 => ALL +1), (0 => ALL -1)
      REAL*8 p
C     TEMPERATURE (TEMP := k_B·T)
      REAL*8 TEMP
C     H (:= Γ = TRANSVERSE FIELD)
      REAL*8 H
C     p-LIST, TEMP-LIST, Γ-LIST
      INTEGER p_SIZE, TEMP_SIZE, H_SIZE
      REAL*8,ALLOCATABLE:: p_LIST(:), TEMP_LIST(:), H_LIST(:)
C-----(SIMULATION)---------------------------------------------
C     NUMBER OF GRAPHS TO SIMULATE FOR EVERY P VALUE
      INTEGER NSEEDS
C     SEED NUMBER, INITIAL SEED NUMBER
      INTEGER SEED, SEEDini
      PARAMETER(SEEDini = 100)
C-----(OBSERVABLES)-------------------------------------------
C     SIZE
      INTEGER SIZE
      PARAMETER(SIZE = 9)
C     SELF OVERLAP
      REAL*8 QSELF(1:SIZE), QSELF_I
C     OVERLAP BETWEEN TWO CONFIGURATIONS
      REAL*8 Q(1:SIZE), Q_I
C-----(DUMMY)-------------------------------------------------
      INTEGER ITEMP, IH, Ip
      CHARACTER(4) str
      CHARACTER(3) str1, str2, str3, str4
C~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

C-----------------------------------------------------------------------
C     START
C-----------------------------------------------------------------------

      PRINT*, 'OBSERVABLES'

C***********************************************************************
C     READ SIMULATION VARIABLES FROM INPUT FILE
      CALL READ_INPUT(N,z,R,TEMP_SIZE,TEMP_LIST,H_SIZE,H_LIST,
     . p_SIZE,p_LIST,NSEEDS)

C***********************************************************************
      CALL SYSTEM('mkdir -p results/data/')
      OPEN(UNIT=1,FILE='results/data/q.dat')
C***********************************************************************

C     FOR ALL TEMP VALUES
      DO ITEMP = 1,TEMP_SIZE
      TEMP = TEMP_LIST(ITEMP)
      WRITE(str,'(f4.2)') TEMP
      str1 = str(1:1)//str(3:4)

C     FOR ALL Γ VALUES      
      DO IH = 1,H_SIZE
      H = H_LIST(IH)
      WRITE(str,'(f4.2)') H
      str2 = str(1:1)//str(3:4)

C     FOR ALL p VALUES
      DO Ip = 1,p_SIZE
      p = p_LIST(IP)
      WRITE(str,'(f4.2)') p
      str3 = str(1:1)//str(3:4)

C***********************************************************************
C     RESET OBSERVABLES
      QSELF = (/0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0/)
      Q = QSELF
C***********************************************************************

C     FOR ALL SEEDS
      DO SEED = SEEDini,SEEDini+NSEEDS-1
      WRITE(str4,'(i3)') SEED

C***********************************************************************
C     READ OVERLAPS FILE
      OPEN(UNIT=3,FILE='results/overlaps/T'//str1//'_Γ'//str2//
     .'/Q_'//str3//'_'//str4//'.dat')

C     READ OVERLAPS
      DO I = 1,SIZE
            READ(3,*) IMC , QSELF_I, Q_I
            QSELF(I) = QSELF(I) + QSELF_I
            Q(I) = Q(I) + Q_I
      END DO
C***********************************************************************
      CLOSE(3)
C***********************************************************************

      END DO !SEED

C***********************************************************************
C     SAVE OBSERVABLES
      WRITE(1,*) TEMP, H, p, QSELF/NSEEDS, Q/NSEEDS
C***********************************************************************

      END DO !Ip
      END DO !IH
      END DO !ITEMP

C***********************************************************************
      CLOSE(1)
C***********************************************************************

      END PROGRAM OBSERVABLES