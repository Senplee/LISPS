jinbox_plot :dialog  {
	label="Plot-Drawing at Custmize Box";
	:row {
		:column {
			:boxed_column {
				label="출력장치 설정";
				:popup_list {
					label="출력프린터:";
					value="0";
					key="jplot1";
					list="JIN14 \nPLOT \nPlotter \n \n \n \n \n \n \n \nA3";
//							0		1			2			3	4	5	6	7	8	9	10
				}
				:popup_list {
					label="용지사이즈:";
					value="0";
					key="jplot2";
					list="A3 \nA4 \nA1-가로 \nA1-세로 \n \n \n";
				}
				:popup_list {
					label="선색상종류:";
					value="0";
					key="jplot11";
					list="흑백 \n칼라 \n \n \n \n \n";
				}
			}
			:boxed_row {
				label="출력축척 설정";
				:column {
					:radio_button {
						label="임의축척:";
						key="jplot3";
					}
					:radio_button {
						label="도면축척*2:";
						key="jplot4";
					}
					:radio_button {
						label="축척없음:";
						key="jplot5";
					}
				}
				:column {
					:edit_box {
//			         label="임의축척:";
						key="jplot3a";
						value=1.0;
						width=7;
					}
					:text {
						label="1 : 1";
						key="jplot4a";
					}
					:text {
						label=" = Fit ";
						key="jplot5a";
					}
				}
			}
		}
		:boxed_row {
			label="출력범위 설정";
			:column {
				:radio_button {
					label="범위 지정(W)";
					key="jplot6a";
					value=1;
				}
				:radio_button {
					label="리미트 값(L)";
					key="jplot7a";
					value=0;
				}
				:radio_button {
					label="보이는대로(V)";
					key="jplot8a";
					value=0;
				}
				:radio_button {
					label="도면 전체(E)";
					key="jplot9a";
					value=0;
				}
				:spacer { width=1; }
				:spacer { width=1; }
			}
//			:column {
//				:button {
//					label="범위 지정";
//					key="jplot6";
//				}
//				:button {
//					label="리미트 값";
//					key="jplot7";
//				}
//				:button {
//					label="보이는대로";
//					key="jplot8";
//				}
//				:button {
//					label="도면 전체";
//					key="jplot9";
//				}
//				:spacer { width=1; }
////				:spacer { width=1; }
////				:spacer { width=1; }
////				:spacer { width=1; }
//			}
		}
	}
	:spacer { width=1; }
	:spacer { width=1; }
	:boxed_row {
		label="미리보기";
//		:toggle {
//			key="jplot10a";
//		}
		:button {
			label="미리보기로 바로실행함";
			key="jplot10";
			value=0;
		}
	}
	ok_cancel;
}
