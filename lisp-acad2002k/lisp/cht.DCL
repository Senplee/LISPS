// 작업날짜: 2000년 7월 18일
// 작업자: 박율구
// 명령어: CIMCHT

dd_cht : dialog {
         label = "문자 속성 변경";
         : text {
              label = "내용";
         }
         : edit_box {
              key = "ed_content";
         }     
         : boxed_column {
           : row {
              spacer_1;
              : text { label = "                       현재";}
              : text { label = " 변경";}
           }
           : row {
             : text { label = "높이        :";}
             : edit_box { key = "ed_oldh";}
             : edit_box { key = "ed_newh";}
           }
           : row {
             : text { label = "자리맞춤:";}
             : edit_box { key = "ed_oldj";}
             : popup_list { key = "pop_newj";}
           }
           : row {
             : text { label = "회전        :";}
             : edit_box {  key = "ed_oldr";}
             : edit_box { key = "ed_newr";}
           }
           : row {
             : text { label = "유형        :";}
             : edit_box { key = "ed_olds";}
             : popup_list { key = "pop_news";}
           }
           : row {
             : text { label = "폭요인    :";}
             : edit_box { key = "ed_oldw";}
             : edit_box { key = "ed_neww";}
           }
         }
         ok_cancel;
}         
         