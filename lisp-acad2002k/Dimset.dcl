//
//     Dimput AutoCad Dialog Box
//     File  : dimset.dcl
//     Made by Shin Jong-Hwa
//

dcl_settings : default_dcl_settings { audit_level = 1; }

initdraw :dialog {
            label = "Initialize Drawing";
            initial_focus = "__SCALE__";
            :column {
                :boxed_row {
                    label = "OPTIONS";
                    :edit_box {
                       label= "SCALE       1     :";
                       mnemonic = "S";
                       key = __SCALE__;
                       allow_accept = true;
                    }
                    :spacer { width = 5; }
                    :toggle {
                       label = "Grid ON";
                       key = __GRID__;
                       mnemonic = "G";
                       key = __GRID__;
                    }
                }
            }
            :column {
               :boxed_row {
                    label = "BORDER INSERT";
                  :column {
                    :boxed_row {
                        label = "BORDER TYPE";
                        :radio_button {
                          label = "Xref Border";
                          key = __XREF__;
                          mnemonic = "X";
                        }
                        :radio_button {
                          label = "Block Border";
                          key = __BLOCK__;
                          mnemonic = "B";
                        }
                        :radio_button {
                          label = "None";
                          key = __NONE__;
                          mnemonic = "N";
                        }
                    }
                    :row {
                      :edit_box {
                        label = "BORDER DWG FILE :";
                        key = __FILE__;
                        width = 40;
                        mnemonic = "F";
                      }
                      :button {
                        label = "Load";
                        mnemonic = "L";
                        key = __FILELOAD__;
                      }
                    }
                  }
               }
            }
            ok_cancel;
}

dimset :dialog {
          label = "Setting Dimput Option";
          initial_focus = "t_scale";
          :column { 
                :row {
                       :boxed_column {
                            label = "Preview";
                            :image_button {
                                 key = "dimt";
                                 height = 8;
                                 aspect_ratio = 2;
                                 color = 0;
                                 allow_accept = false;
                            }
                            :edit_box {
                                 label = "Extend Line :";
                                 width = 8;
                                 key = "extend";
                                 mnemonic = "E";
                                 allow_accept = true; 
                            }              
                            :edit_box {
                                 label = "Scale          : ";
                                 width = 8;
                                 key = "t_scale";
                                 mnemonic = "S";
                                 allow_accept = true;
                            }
							:edit_box {
                                 label = "Dim Scale    :";
                                 width = 8;
                                 key = "t_dimscale";
                                 mnemonic = "C";
                                 allow_accept = true;
                            }
                            :edit_box {
                                 label = "Scale Factor:";
                                 width = 8;
                                 key = "t_scalefactor";
                                 mnemonic = "c";
                                 allow_accept = true; 
                            }
                            :edit_box {
                                 label = "DIMEXO       :";
                                 width = 8;
                                 key = "dimexo_";
                                 allow_accept = true; 
                            }
                            spacer;
                       } 
                       :boxed_column {
                            label = "Type";
                            :radio_column {                                      
                                 :radio_button {
                                       label=" 1";
                                       key = "radio1";
                                       mnemonic = "1";
                                 }
                                 :radio_button {
                                       label=" 2";
                                       key = "radio2";
                                       mnemonic = "2";
                                 }
                                 :radio_button {
                                       label=" 3";
                                       key = "radio3";
                                       mnemonic = "3";
                                 }      
                                 :radio_button {
                                       label=" 4";
                                       key = "radio4";
                                       mnemonic = "4";
                                 }      
                                 :radio_button {
                                       label=" 5";
                                       key = "radio5";
                                       mnemonic = "5";
                                 }
                                 :radio_button {
                                       label=" 6";
                                       key = "radio6";
                                       mnemonic = "6";
                                 }
                                 :radio_button {
                                       label=" 7";
                                       key = "radio7";
                                       mnemonic = "7"; 
                                 }      
                                 :radio_button {
                                       label=" 8";
                                       key = "radio8";
                                       mnemonic = "8";
                                 }      
                                 :radio_button {
                                       label="User";
                                       key = "radio9";
                                       mnemonic = "U";
                                 }  
                        }         
                }                  
               :column {
                 :boxed_column {
                      label = "Metric format";
                      :radio_button {
                              label="Melimeter(mm)";
                              key = "mm";
                              mnemonic = "M";
                      }
                      :radio_button {
                              label="Meter(m)";
                              key = "miter";
                              mnemonic = "t";
                      }                     
                 }                
                 :boxed_column {
                      label = "Text Arrange";
                      :radio_button {
                              label="Unit";
                              key = "Unit";
                              mnemonic = "U";
                      }
                      :radio_button {
                              label="Unit+Total";
                              key = "Spread";
                              mnemonic = "s";
                      }
                      :radio_button {
                              label="Number";
                              key = "Numbering";
                              mnemonic = "n";
                      }
                      :radio_button {
                              label="Number+Total";
                              key = "Number2";
                              mnemonic = "n";
                      }
                 }
                 :toggle {
                     label = "Save Settings";
                     key = "SAVESET";
                     mnemonic = "S";
             }
              }            
            }   
          }
          :column {
            :row {
			  :button {
                 label = "홈페이지";
                 key = "b_web";
              }
              :spacer {width=1;}
              :button {
                 label = "DDIM";
                 key = "b_ddim";
              }
              :spacer {width=1;}
              :button {
                 label = "Color";
                 key = "b_color";
              }
              :spacer {width=1;}
              :button {
                 label = "Detail";
                 key = "b_detail";
              }
              :spacer {width=1;}
              :column {
                :spacer {width=1; height=1;}
                ok_cancel_help_errtile;
              }
            }
          }
} 

dimdetail : dialog {
        label = "Detail Setting";
        :row {
          :boxed_column {
             label = "DimPut Option";
             :toggle {
                     label = "Use a Cad DIMEXO";
                     key = "caddimexo";
                     mnemonic = "x";
             }
             :toggle {
                     label = "Auto Size.";
                     key = "_AUTOSIZE_";
                     mnemonic = "u";
             }
             :toggle {
                    label="Delete Object";
                    key = "Del";
                    mnemonic = "D";
             }
             :toggle {
                    label="Use My Arc";
                    key ="darc";
                    mnemonic="A";
             }
             :toggle {
                     label = "Use a Civil Strct.";
                     key = "_CIVIL_";
                     mnemonic = "a";
             }
             :popup_list {
                     label = "D.P.:";
                     dit_width = 10;
                     key = "_decimal_";
                     mnemonic = "D";
             }
           }
           :boxed_column {
             label = "Quick Dim Setting";
             :toggle {
                    label = "Forced Inside";
                    key = "inside";
                    mnemonic = "F";
             }
             :toggle {
                    label = "Extend Line Fix.";
                    key = "_FIX_";
                    mnemonic = "L";
             }
             :toggle {
                    label="Zero Supression";
                    key = "ZeroSup";
                    mnemonic = "Z";
             }
             :edit_box {
                   label = "Angle : ";
                   key = "Angle";
                   mnemonic = "A";
             }
			:edit_box {
                   label = "Layer : ";
                   key = "Layer";
                   mnemonic = "L";
             }
			:edit_box {
                   label = "Text Height : ";
                   key = "TextHeight";
                   mnemonic = "T";
             }           		  
           }
         }
         :row {
           :boxed_column {
              label = "DIMASO";
              :radio_button {
                 label = "Explode";
                 key = "kExplode";
                 mnemonic = "x";
              }
              :radio_button {
                 label = "Block";
                 key = "kBlock";
                 mnemonic = "B";
              }
            }
			:boxed_column {
              label = "DIMDOT";
              :radio_button {
                 label = "Use Dot";
                 key = "UseDot";
                 mnemonic = "D";
              }
              :radio_button {
                 label = "Use Comma";
                 key = "UseComma";
                 mnemonic = "C";
              }
            }
            :boxed_column {
              label = "Text Pos";
              :radio_button {
                 label="Up";
                 key = "Up";
                 mnemonic = "p";
              }
              :radio_button {
                 label="Middle";
                 key = "Middle";
                 mnemonic = "M";
              }
              :radio_button {
                 label="Down";
                 key = "Down";
                 mnemonic = "D";
              }
           }
           :boxed_column {
              label = "ArrowHead";
              :radio_button {
                 label="Arrow";
                 key = "Arrow";
                 mnemonic = "A";
              }
              :radio_button {
                 label="Dot";
                 key = "Dott";
                 mnemonic = "d";
              }
              :radio_button {
                 label="Oblique";
                 key = "Oblique";
                 mnemonic = "O";
              }
          }
         }
         ok_cancel;
         spacer;
}


dimcolor : dialog {
       label = "Dim Color";
       :row {
         :boxed_row {
          label = "Dimension Line Color";
          : image_button {
              key = "s_dimcolor";
              height = 1;
              width = 3;
          }
          :button {
             label = "Change..";
             key   = b_dimcolor;
          }
         }
       }
       :row {
         :boxed_row {
          label = "Extension Line Color";
          : image_button {
              key = "s_extcolor";
              height = 1;
              width = 3;
          }
          :button {
             label = "Change..";
             key   = b_extcolor;
          }
         }
       }
       :row {
         :boxed_row {
          label = "Text Color";
          : image_button {
              key = "s_textcolor";
              height = 1;
              width = 3;
          }
          :button {
             label = "Change..";
             key   = b_textcolor;
          }
         }
       }
       ok_cancel;
}

dimnew : dialog {
       label = "input string";
       initial_focus = "t_newtext";
       :edit_box {
             label = "Enter New Text:";
             width = 55;
             key = "t_newtext";
             allow_accept = true;
       }
       ok_cancel;
}

dimchange : dialog {
       label = "Input String";
       initial_focus = "t_chgtext";
       :edit_box {
             label = "Enter New Text:";
             width = 55;
             key = "t_chgtext";
             allow_accept = true;
       }
       ok_cancel;
}

dimlogo : dialog {
       label = "DimPut Ver 2.2";
       :image {
             key="logo"; 
             width=45;
             color = 0;
             aspect_ratio = 0.7;
             allow_accept = false;  
       }
       ok_only;                    
}  

dcal : dialog {
       label = "Input Calculation Text";
       initial_focus = "_CALTEXT";
       :row {
       :edit_box {
             label = "Enter Text:";
             width = 55;
             key = "_CALTEXT";
             allow_accept = true;
       }
       :button {
             label="AddIn";
             key = "AddIn";
             width = 3;
         }    
       }
       ok_cancel;
}

title : dialog {
       label = "Input Title";
       initial_focus = "t_titletext";
       :row {
       :edit_box {
             label = "Enter Text:";
             width = 90;
             key = "t_titletext";
             allow_accept = true;
       }
       :spacer { witdh =0.1;}
       :button {
             label="SInput";
             key = "SIN";
             width = 2;
         }
         :spacer { witdh =0.1;}
       }
              :row {
                :radio_button {
                    label="Large Title(10)";
                    key = "r0";
                    mnemonic= "L";
                 }
                :radio_button {
                    label="Title(8)";
                    key = "r1";
                    mnemonic = "T";
                 }
                :radio_button {
                    label="Middle Title(7)";
                    key = "r2";
                    mnemonic = "M"; 
                }      
                :radio_button {
                    label="Small Title(6)";
                    key = "r3";
                    mnemonic = "S";
                }      
                :radio_button {
                    label="Scale & NOTE(3)";
                    key = "r4";
                    mnemonic = "E";
                }  
                :radio_button {
                    label="Dim Text(2.5)";
                    key = "r5";
                    mnemonic = "D";
                }  
       } 
       ok_cancel;

}

Result : dialog {
       label = "Cheking Result";
       :list_box {
             label = "Result List:";
             key = "rlist";
             width = 40;
             height = 20;
       }
       ok_only;
}

dinsert : dialog {
    label = "정형화된 블럭 삽입";
    :row {
        :column {
          :text {
            label = "          << 블럭 대분류 >>";
          }
          :list_box {
             key = "ITEMLIST";
             height = 15;
          }
          :row {
            :edit_box {
              label = "스케일";
              key = "ScaleEdit";
              width = 2;
            }
          }
          :row {
            :edit_box {
              label = "각도";
              key = "RotateD";
              width = 2;
            }
            :toggle {
              label = "사용자";
              key = "UserD";
            }
          }
          :row {
            :toggle {
              label = "삽입 동시에 EXPLODE";
              key = "Explode";
            }
          }
          :row {
             :text_part { label = "블럭 이름 : "; width = 3; }
             :text_part { key = "K_LSTDWG"; label = "없음"; width= 14; }
          }
        }
        : column {
            : image_button {             
                key = "K_01";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
           }
            : image_button {            
                key = "K_05";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {            
                key = "K_09";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {            
                key = "K_13";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_17";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
          }
         :column {
            : image_button {
                key = "K_02";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_06";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_10";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_14";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_18";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
        }
        :column {
            : image_button {
                key = "K_03";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_07";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_11";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_15";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_19";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
        }
        :column {
            : image_button {
                key = "K_04";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_08";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_12";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_16";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_20";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
        }
     }
     :row {
       :button {
          label = "<<";
          key = "Prev";
          width = 3;
       }
       :button {
          label = ">>";
          key = "Next";
          width = 3;
       }
       :button {
          label = "Edit";
          key   = "Edit";
          width = 3;
       }
       :button {
          label = "Append";
          key   = "Append";
          width = 3;
       }
       ok_cancel;
     }
 }

jijil : dialog {
  label = "지질 주상도 그리기";
  :row {
    :column{
     :image_button {
               key = "jview";
               width = 15;
               color = 0;
               allow_accept = false;
     }
     :edit_box {
          label = "Scale : ";
          width = 15;
          key = "Scale";
     }
    }
    :column {
      :row {
        :text {
          label = "측점번호 (상):";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "Bun";
        }
      }
      :row {
        :text {
          label = "측점번호 (하):";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "Bun1";
        }
      }
      :row {
        :text {
          label = "위치 :";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "Pos";
        }
      }
      :row {
        :text {
          label = "시작점 E.L:";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "St";
        }
      }
      :row {
        :text {
          label = "실     트";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J0";
        }
      }
      :row {
        :text {
          label = "점     토";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J1";
        }
      }
      :row {
        :text {
          label = "점토섞인 모래";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J2";
        }
      }
      :row {
        :text {
          label = "실트섞인 모래";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J3";
        }
      }
      :row {
        :text {
          label = "점토섞인 자갈";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J4";
        }
      }
      :row {
        :text {
          label = "실트섞인 자갈";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J5";
        }
      }
      :row {
        :text {
          label = "전     석";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J6";
        }
      }
      :row {
        :text {
          label = "풍  화  암";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J7";
        }
      }
      :row {
        :text {
          label = "연     암";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J8";
        }
      }
      :row {
        :text {
          label = "경     암";
          width = 15;
        }
        :edit_box {
          width = 15;
          key = "J9";
        }
      }
     }
   }
   ok_cancel;
  }

YesNo : dialog {
     label = "물음";
     :text {
        key = "YN_Text";
     }
     width = 80;
     ok_cancel;
}

command : dialog {
    label = "ICON 명령관리기";
    :row {
        :column {
          :text {
            label = "                      << 명령어 설명 >>";
          }
          :list_box {
             key = "ITEMLIST";
             width = 40;
             height = 20;
          }
        }
        : column {
            : image_button {             
                key = "K_01";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
           }
            : image_button {            
                key = "K_05";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {            
                key = "K_09";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {            
                key = "K_13";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_17";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
          }
         :column {
            : image_button {
                key = "K_02";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_06";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_10";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_14";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_18";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
        }
        :column {
            : image_button {
                key = "K_03";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_07";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_11";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_15";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_19";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
        }
        :column {
            : image_button {
                key = "K_04";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_08";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_12";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_16";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
            : image_button {
                key = "K_20";
                width = 12;
                color = 0;
                aspect_ratio = 0.4;
                allow_accept = true;
            }
        }
     }
     :row {
       :button {
          label = "<<";
          key = "Prev";
          width = 3;
       }
       :button {
          label = ">>";
          key = "Next";
          width = 3;
       }
       ok_cancel;
     }
 }

addblk :dialog {
          label = "Append";
          :boxed_row {
            :radio_button {
              label="TITLE";
              key = "TITLE";
              width = 3;
            }
            :radio_button {
              label="BLOCK";
              key = "BLOCK";
              width = 3;
            }
          }
          :row {
           :edit_box {
             label="TITLE or Name";
             key="Edit";
             width=40;
           }
           :button {
             label="...";
             key="AppendB";
             width=2;
           }
          }
          ok_cancel;
}
