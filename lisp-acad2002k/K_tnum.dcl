//김희태 (영조건설 or 모든기획 tel:02-324-1456) 가 만든 텍스트숫자를 
//일률적으로 주어진 값에 +,-,/,x 하는 리습입니다.
//의문점이나 잘못된점이 있으면 위의 전화로 연락하거나
//메일주세요. 하이텔id:xoutside
union:dialog {
      label = "텍스트 숫자에 -,+,/,* 일률적으로 하기";
         initial_focus = "ebox";
       :row{
        label="연산자";
       :radio_button{
        label=" + ";
        key="button+";
        }
       :radio_button{
        label=" -- ";
        key="button-";
        }
       :radio_button{
        label=" / ";
        key="button/";
        }
       :radio_button{
        label=" X ";
        key="button*";
        }
       }
       spacer;
       :row{
        label="소숫점 자리수";
       :radio_button{
        label=" 0 ";
        key="button0";
        }
       :radio_button{
        label=" 1 ";
        key="button1";
        }
       :radio_button{
        label=" 2 ";
        key="button2";
        }
       :radio_button{
        label=" 3 ";
        key="button3";
        }
       :radio_button{
        label=" 4 ";
        key="button4";
        }
       :radio_button{
        label=" 5 ";
        key="button5";
        }
       }
       
       :row {
        :list_box{         key="lbox1";width=17;           fixed_width = true; }
        :text {label="   "; key = "total";}
        :edit_box{
       //label="Scale:";
         key="ebox";

         width=8;
         }
        :text {label="=";}
        :list_box{key="lbox2";width=20;           fixed_width = true; }
       }
        :row {
          :button {label="결과값 보기"; key="bt1";}
          :button {label="출   력"; key="accept"; is_default=true;       }// allow_accept=true;}
          // cancel_only;
          :button {label="취   소"; key="cancel";}
        }
} 
