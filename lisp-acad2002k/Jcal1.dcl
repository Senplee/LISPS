dcl_settings : default_dcl_settings { audit_level = 3; }
cal : dialog {
   value = "GNO Calculator " ;
   key = "calculator" ;
   : column {
      : edit_box {
         alignment = right ;
         allow_accept = true ;
         edit_limit = 1000 ;
         key = "dis" ;
         fixed_width = true ;
         width = 20 ;
      }
      : row {
         : text {
            label = " = " ;
         }
         : text {
            is_bold = true ;
            key = "answer" ;
            label = "  " ;
            fixed_width = true ;
            width = 16 ;
         }
      }
      : column {
         : row {
            children_fixed_height = true ;
            width = 2 ;
            : button {
               key = "7" ;
               label = "7" ;
               fixed_width = true ;
               width = 2 ;
            }
            : button {
               key = "8" ;
               label = "8" ;
               fixed_width = true ;
               width = 2 ;
            }
            : button {
               key = "9" ;
               label = "9" ;
               fixed_width = true ;
               width = 2 ;
            }
            : button {
               key = "+" ;
               label = "+" ;
               fixed_width = true ;
               width = 2 ;
            }
         }
         : row {
            : button {
               key = "4" ;
               label = "4" ;
            }
            : button {
               key = "5" ;
               label = "5" ;
            }
            : button {
               key = "6" ;
               label = "6" ;
            }
            : button {
               key = "-" ;
               label = "-" ;
            }
         }
         : row {
            : button {
               key = "1" ;
               label = "1" ;
            }
            : button {
               key = "2" ;
               label = "2" ;
            }
            : button {
               key = "3" ;
               label = "3" ;
            }
            : button {
               key = "/" ;
               label = "/" ;
            }
         }
         : row {
            : button {
               key = "0" ;
               label = "0" ;
            }
            : button {
               key = "(" ;
               label = "(" ;
            }
            : button {
               key = ")" ;
               label = ")" ;
            }
            : button {
               key = "*" ;
               label = "*" ;
            }
         }
         : row {
            : button {
               key = "." ;
               label = "." ;
               fixed_width = true ;
               width = 2 ;
            }
            : button {
               key = "<" ;
               label = "<-" ;
               width = 2 ;
            }
            : button {
               key = "clear" ;
               label = "CL" ;
            }
            : button {
               key = "=" ;
               label = "=" ;
            }
         }
      }
      : row {
      }
   }
   ok_only;
}



