000000210811          DCL-f DayDsp Workstn;                                                                     
000000210811          // Declare procedure interface                                                            
000000210811          // we pass in the name of type of solution we're showing                                  
000000210811          Dcl-PI  Main  extPgm('DAYSRPG');                                                          
000000210811             Solution   char(15);                                                                   
000000210811         End-PI;                                                                                    
000000210811      // COPY THE PROTOTYPE HERE                                                                    
000000210811      /COPY LAB10,DAYPROTO                                                                          
000000210811           EXFMT INPUT;                                                                             
000000210811           DOW NOT(*IN03);                                                                          
000000210811              DayName = DayNumName(DayIn);                                                          
000000210811              *in99 = *on;                                                                          
000000210811               WRITE INPUT;                                                                         
000000210811               EXFMT OUTPUT;                                                                        
000000210811              *in99 = *off;                                                                         
000000210811               IF *IN03 = '0';                                                                      
000000210811                 DayIn = 0;                                                                         
000000210811                 EXFMT INPUT ;                                                                      
000000210811               ENDIF;                                                                               
000000210811            ENDDO;                                                                                  
000000210811            *INLR = *ON;                                                                            
000000210811            RETURN;                                                                                 
000000210811                                                                                                    
000000210811                                                                                                    
