      SUBROUTINE CLOSEX(Z,IMAX,JMAX,S,A,B,M,JUP,LOX,
     X           ITABMB,ITABFL,MXITR,LPLMI,IFF)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C                .      .    .                                       .
C SUBPROGRAM:    CLOSEX      DESCRIPTIVE TITLE NOT PAST COL 70
C   PRGMMR: KRISHNA KUMAR         ORG: W/NP12   DATE: 1999-08-01
C
C ABSTRACT: FINDS LOCATIONS OF ALL CENTERS IN THE GIVEN FIELD
C   IN ORDER TO CALL S/R CLOSED WHICH, IN TURN, LABELS THE
C   CONTOURS ABOVE THE CENTERS.
C
C PROGRAM HISTORY LOG:
C   ??-??-??  DICK SCHURR
C   93-04-07  LILLY         CONVERT SUBROUTINE TO FORTRAN 77
C 1999-08-01  KRISHNA KUMAR CONVERTED THIS CODE FROM CRAY TO IBM
C                           RS/6000. ASSIGNED PROPER VALUE TO INDEFF
C                           USING RANGE FUNCTION FOR IBM RS/6000 FOR
C                           COMPILE OPTIONS xlf -qintsize=8 -qrealsize=8
C
C USAGE:    CALL CLOSEX( Z, IMAX, JMAX, S, A, B, M, JUP, LOX,
C                        ITABMB, ITABFL, MXITR, LPLMI, IFF )
C   INPUT ARGUMENT LIST:
C     INARG1   - GENERIC DESCRIPTION, INCLUDING CONTENT, UNITS,
C     INARG2   - TYPE.  EXPLAIN FUNCTION IF CONTROL VARIABLE.
C
C   OUTPUT ARGUMENT LIST:      (INCLUDING WORK ARRAYS)
C     WRKARG   - GENERIC DESCRIPTION, ETC., AS ABOVE.
C     OUTARG1  - EXPLAIN COMPLETELY IF ERROR RETURN
C     ERRFLAG  - EVEN IF MANY LINES ARE NEEDED
C
C   INPUT FILES:   (DELETE IF NO INPUT FILES IN SUBPROGRAM)
C     DDNAME1  - GENERIC NAME & CONTENT
C
C   OUTPUT FILES:  (DELETE IF NO OUTPUT FILES IN SUBPROGRAM)
C     DDNAME2  - GENERIC NAME & CONTENT AS ABOVE
C     FT06F001 - INCLUDE IF ANY PRINTOUT
C
C REMARKS: LIST CAVEATS, OTHER HELPFUL HINTS OR INFORMATION
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 90
C   MACHINE:  IBM
C
C$$$
C
      CHARACTER*8  IFF(5)
      REAL      Z(IMAX,JMAX)
      INTEGER   ITABMB(MXITR)
      INTEGER   ITABFL(MXITR)
C
      CHARACTER*4  LPLMI
C
      REAL   INDEF,KDEF1,KDEF2
C
      INTEGER      M(2)
C
      DATA  INDEF   /1.0E307 /
C
C     INITIALIZE FOR CENTER SEARCH
C
      IMIN=1
      JMIN=1
      ITST=1
  10  ILOW=0
      IHIGH=0
      DO 100 J=JMIN,JMAX
      DO 100 I=IMIN,IMAX
C
C     TEST FOR BORDER VALUES.
C
      IF(I.LE.IMIN+1.OR.I.GE.IMAX-1) GO TO 100
      IF(J.LE.JMIN+1.OR.(J+JUP).GE.JMAX-1) GO TO 100
C
C     TEST FOR UNDEFINED VALUES.
C
      KDEF1=Z(I-1,J)
      KDEF2=Z(I+1,J)
      IF((KDEF1.EQ.INDEF).OR.(KDEF2.EQ.INDEF)) GO TO 100
      KDEF1=Z(I-1,J-1)
      KDEF2=Z(I-1,J+1)
      IF((KDEF1.EQ.INDEF).OR.(KDEF2.EQ.INDEF)) GO TO 100
      KDEF1=Z(I+1,J-1)
      KDEF2=Z(I+1,J+1)
      IF((KDEF1.EQ.INDEF).OR.(KDEF2.EQ.INDEF)) GO TO 100
      KDEF1=Z(I,J+1)
      KDEF2=Z(I,J-1)
      IF((KDEF1.EQ.INDEF).OR.(KDEF2.EQ.INDEF)) GO TO 100
C
C     TEST FOR LOW CENTER
C
      IF(Z(I,J).GE.Z(I+1,J)) GO TO 30
      IF(Z(I,J).GE.Z(I,J+1)) GO TO 30
      IF(Z(I,J).GT.Z(I,J-1)) GO TO 30
      IF(Z(I,J).GT.Z(I-1,J)) GO TO 30
      IF(Z(I,J).GE.Z(I-1,J+1)) GO TO 30
      IF(Z(I,J).GE.Z(I+1,J+1)) GO TO 30
      IF(Z(I,J).GT.Z(I-1,J-1)) GO TO 30
      IF(Z(I,J).GT.Z(I+1,J-1)) GO TO 30
C
C     FOUND LOW CENTER
C
      ITYPE=1
      ILOW=ILOW+1
      GO TO 50
C
C     TEST FOR HIGH CENTER
C
  30  IF(Z(I,J).LE.Z(I+1,J)) GO TO 100
      IF(Z(I,J).LE.Z(I,J+1)) GO TO 100
      IF(Z(I,J).LT.Z(I,J-1)) GO TO 100
      IF(Z(I,J).LT.Z(I-1,J)) GO TO 100
      IF(Z(I,J).LE.Z(I-1,J+1)) GO TO 100
      IF(Z(I,J).LE.Z(I+1,J+1)) GO TO 100
      IF(Z(I,J).LT.Z(I-1,J-1)) GO TO 100
      IF(Z(I,J).LT.Z(I+1,J-1)) GO TO 100
C
C     FOUND HIGH CENTER
C
      ITYPE=2
      IHIGH=IHIGH+1
  50  CONTINUE
C
C     FOUND CENTER-GO GET CONTOUR LABEL
C
      IFIX=I
      JFIX=J
      CALL CLOSEY(Z,IMAX,JMAX,S,A,B,M,JUP,IFIX,JFIX,LOX,
     XITABMB,ITABFL,MXITR,LPLMI,IFF)
      ITST=0
 100  CONTINUE
 110  RETURN
      END
