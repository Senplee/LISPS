// 작성날짜: 2000.4.29
// 작업자: 박율구
// 요약: CIMSTART에서 초기환경설정 정보 출력 폼


dcl_settings : default_dcl_settings { audit_level = 0; }

informbox:dialog{
            label="초기 환경설정 정보";
            //fixed_width=10;
		:text{
			label="                     도면 설정 완료.";
		}
         :boxed_column{
              :row{
	    	  :text{
	       	      	label="현재 도면축적:";
	 	  }
	 	  :text{
	 	        key="scale";
	 	        width=5;
	 	        alignment=centered;
	 	  }
	 	}
	      :row{
	 	  :text{
	 		label="현재 도면크기:";
	 		}
	 	  :text{
	 	        key="size";
	 	        width=5;
	 	        alignment=centered;
	 	       }
	 	  }
	      :row{
	 	  :text{
	 		label="현재 치수유형:";
	 		}
	 	  :text{
	 	        key="dim";
	 	        width=5;
	 	        alignment=centered;
	 	       }
	 	  }
	      :row{
	 	  :text{
	 		label="현재 문자유형:";
	 		}
	 	  :text{
	 	        key="style";
	 	        width=5;
	 	        alignment=centered;
	 	       }
	 	  }
	      :row{
	 	  :text{
	 		label="Snap 간격:";
	 	       }
	 	  :text{
	 	       key="snap";
	 	       width=5;
	 	       }
	 	  :text{
	 		label="Grid 간격:";
	 	       }
	 	  :text{
	 	        key="grid";
	 	        width=5;
	 	       } 
	 	  }
	 	:spacer{width=2;}
	      } 	
	 ok_only;
	 }