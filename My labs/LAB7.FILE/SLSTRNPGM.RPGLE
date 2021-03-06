000100210717       DCL-F UPDREPORT  PRINTER OflInd(*IN01);
000101210717         DCL-F SALESTRANS DISK(*EXT) KEYED USAGE(*INPUT)
000102210717               RENAME(SALESTRANS:SALESTRANR);
000103210718         DCL-F SALESSTAF2 DISK(*EXT) KEYED
000104210717               USAGE(*UPDATE : *OUTPUT : *DELETE);
000105210717         DCL-DS FullKey ;
000106210717               ADept    CHAR(3);
000107210717               ASalesId CHAR(4);
000108210717         END-DS FullKey;
000109210717         DCL-DS SalesTransDS;
000110210717               TDept;
000111210717               TSalesId;
000112210717               TFName;
000113210717               TLName;
000114210717               TCity;
000115210717               TAddress;
000116210717               TPCode;
000117210717         End-Ds SalesTransDs;
000118210718         DCL-DS SALESSTAF2DS;
000119210717               Dept;
000120210717               SalesId;
000121210717               FName;
000122210717               LName;
000123210717               City;
000124210717               Address;
000125210717               PCode;
000126210718         End-Ds SALESSTAF2Ds;
000127210717
000128210717
000129210717                   WRITE   HEADING;
000130210717                   READ      SALESTRANS;
000131210717                   DOW       NOT %EOF;
000132210717                      FULLKEY = TDEPT + TSALESID;
000133210718                      CHAIN  %KDS(FULLKEY) SALESSTAF2;
000134210717                      SELECT;
000135210718                        WHEN      %FOUND(SALESSTAF2);
000136210717                        SELECT;
000137210717                           WHEN      TCODE = 'C';
000138210717                              EXSR      CHGREC;
000139210717                           WHEN      TCODE = 'D';
000140210717                              EXSR      DELREC;
000141210717                           OTHER;
000142210717                              EXSR      ERROR;
000143210717                        ENDSL;
000144210718                        WHEN      NOT %FOUND(SALESSTAF2);
000145210717                           IF        TCODE = 'A';
000146210717                              EXSR      ADDREC;
000147210717                           ELSE;
000148210717                              EXSR      ERROR;
000149210717                           ENDIF;
000150210717                        WHEN      %ERROR;
000151210717                              EXSR      ERROR;
000152210717                        ENDSL;
000153210717                        IF *IN01 = *ON;
000154210717                          WRITE HEADING;
000155210717                          *IN01 = *OFF;
000156210717                        ENDIF;
000157210717                        WRITE    DETAIL;
000158210717                        READ      SALESTRANS;
000159210717                   ENDDO;
000160210717                   *INLR = *ON;
000161210717                   RETURN;
000162210717         BEGSR  ADDREC;
000163210718                 SALESSTAF2DS = SALESTRANSDS;
000164210717                 PHONE = %DEC(TPHONE:10:0);
000165210717                 WRITE SALESTFR;
000166210717         ENDSR;
000167210717         BEGSR  CHGREC;
000168210718                 SALESSTAF2DS = SALESTRANSDS;
000169210717                 PHONE = %DEC(TPHONE:10:0);
000170210717                 UPDATE SALESTFR;
000171210717         ENDSR;
000172210717         BEGSR  DELREC;
000173210717                   DELETE    SALESTFR;
000174210717         ENDSR;
000175210717         BEGSR  ERROR;
000176210717                   TFNAME = 'UPDATE/DELETE/CHANGE';
000177210717                   TLNAME = 'E R R O R';
000178210717         ENDSR;
