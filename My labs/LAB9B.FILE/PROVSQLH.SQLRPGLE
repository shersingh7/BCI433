000100190313       //**************************************************************************
000200191105       //* THIS PROGRAM USES A CURSOR TO LOAD A TEMPORARY RESULT TABLE FROM 3
000300191105       //* SEPARATE TABLES, ONTARIO, QUEBEC AND MANITOBA. A NUMBER IS PASSED
000400191105       //* TO THE PROGRAM TO DETERMINE WHICH RECORDS ARE INLCUDED FROM THE 3 TABLES
000500190313       //**************************************************************************
000600190313           DCL-F PROVREPORT PRINTER OFLIND(*IN01) ;
000700190313           DCL-S ProvinceH    Char(10);
000800190313           DCL-S EndOfFile    IND;
000900190313           DCL-S TotalRecords PACKED(5:0) ;
001000190315             // LowLimit is passed to the program
001100210723             Dcl-PI Main extpgm('PROVSQLH');
001101210723               LowLimitIn Packed(15:5);
001102210723             END-PI;
001200190315
001300190315
001400190315             // All Host Variables available under a single name
001500210723             DCL-DS CustomerRecord;
001501210723               CustId    Char(6);
001502210723               FullName  Char(31);
001503210723               City      Char(20);
001504210723               Purchase  Packed(7:2);
001505210723               PDate     Date;
001506210723               Province  Char(10);
001600210723
002100190315
002200190313        End-Ds CustomerRecord;
002300070123     C/EJECT
002400070123     C**************************************************************************
002500070123     C*                        ***   M A I N   R O U T I N E   ***
002600070123     C**************************************************************************
002700070118      /FREE
002701210723                LowLimit = LowLimitIn;
002800100309                EXSR PrepareFiles;
002900200709                Write ReportHdg;
003000200709                Write RColumns;
003100100309                EXSR GetRow;
003200190313                Write NewProv;
003300070209                ProvinceH = Province;
003400070202                DOW NOT EndOfFile;
003500190313                    IF *IN01 = *ON;
003600210401                        Write ReportHdg;
003700210401                        Write RColumns;
003800190313                       *IN01 = *OFF;
003900070209                    ENDIF;
004000190315                    // Province may change
004100190315
004200210723                    If ProvinceH = Province;
004201210723                     Write Detail;
004202210723                    Else;
004203210723                      ProvinceH = Province;
004204210723                      Write Totals;
004205210723                      TotalPurch = 0;
004206210723                      Write NewProv;
004207210723                      Write Detail;
004208210723                    ENDIF;
004300210723
005200190313                    TotalPurch     = TotalPurch     + Purchase;
005300070202                    TotalRecords= TotalRecords + 1;
005400100309                    EXSR GetRow;
005500070119                ENDDO;
005600190313                Write Totals;
005700070202                EXSR   WRAPUP;
005800190313                Write UnderLimit;
005900070119                *INLR = *ON;
006000070119                RETURN;
006100100309        //**********************************************************************
006200100309        // O P E N F I L E S   S U B R O U T I N E
006300100309        //**********************************************************************
006400100309         BEGSR  PrepareFiles;
006500190315        // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  STRUCTURE
006600210723           EXEC SQL
006601210723               DECLARE ALLPROVCURSOR CURSOR
006602210723                FOR
006603210723
006604210723                SELECT CustId, TRIM(FNAME) || ' ' || LNAME AS FullName,
006605210723                   City, Purchase, PDate,
006606210723                   'Ontario' as Province
006607210723                FROM BCI433LIB/ONTARIO
006608210723                WHERE Purchase > :LowLimit
006609210723                union all
006610210723                SELECT CustId, TRIM(FNAME) || ' ' || LNAME AS FullName,
006611210723                   City, Purchase, PDate,
006612210723                   'Quebec' as Province
006613210723                FROM BCI433LIB/QUEBEC
006614210723                WHERE Purchase > :LowLimit
006615210723                union all
006616210723                SELECT CustId, TRIM(FNAME) || ' ' || LNAME AS FullName,
006617210723                   City, Purchase, PDate,
006618210723                   'Manitoba' as Province
006619210723                FROM BCI433LIB/MANITOBA
006620210723                WHERE Purchase > :LowLimit
006621210723                  FOR READ ONLY;
006700210723
008700190315
008800100309        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D
008900100309
009000210723           EXEC SQL
009001210723             OPEN ALLPROVCURSOR;
009002210723
009003210723             If (SQLCODE <> 0) OR (SQLWN0 = 'W');
009004210723               EndOfFile = *ON;
009005210723             ENDIF;
009100210723
009600100309            ENDSR;
009700100309        //**********************************************************************
009800100309        //   G E T     R O W    S U B R O U T I N E
009900100309        //**********************************************************************
010000210723            BEGSR     GETROW;
010001210723               EXEC SQL
010002210723               FETCH NEXT
010003210723               FROM ALLPROVCURSOR
010004210723               INTO :CustomerRecord;
010005210723
010006210723                If (SQLCODE <> 0) OR (SQLWN0 = 'W');
010007210723                   EndOfFile = *ON;
010008210723                 ENDIF;
010100210723
011100100309             ENDSR;
011200100309        //**********************************************************************
011300100309        // W R A P U P     S U B R O U T I N E
011400100309        //**********************************************************************
011500100309           BEGSR WRAPUP;
011501210723             EXEC  SQL
011502210723              CLOSE ALLPROVCURSOR;
011503210723
011504210723             If SQLCODE <> 0 OR SQLWN0 = 'W';
011505210723               EndOfFile = *ON;
011506210723             ENDIF;
011507210723
011508210723             EXEC SQL
011509210723               SELECT COUNT(*) INTO :ONTTOTAL
011510210723                 FROM BCI433LIB/ONTARIO
011511210723                   WHERE Purchase <= :LowLimit;
011512210723
011513210723             EXEC SQL
011514210723               SELECT COUNT(*) INTO :QUETOTAL
011515210723                 FROM BCI433LIB/QUEBEC
011516210723                   WHERE Purchase <= :LowLimit;
011517210723
011518210723             EXEC SQL
011519210723               SELECT COUNT(*) INTO :MANTOTAL
011520210723                 FROM BCI433LIB/MANITOBA
011521210723                   WHERE Purchase <= :LowLimit;
011522210723
011600100309          ENDSR;
011700210723
