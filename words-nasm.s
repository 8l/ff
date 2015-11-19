 CENTRY `false`, L1, 5
 dd m_literal
 dd 0
 dd m_exit
 CENTRY `true`, L2, 4
 dd m_literal
 dd -1
 dd m_exit
 CENTRY `bl`, L3, 2
 dd m_literal
 dd 32
 dd m_exit
 VENTRY `s0`, L4, 2
 VENTRY `args`, L5, 4
 CENTRY `on`, L6, 2
 dd m_literal
 dd -1
 dd m_xswap
 dd m_store
 dd m_exit
 CENTRY `off`, L7, 3
 dd m_literal
 dd 0
 dd m_xswap
 dd m_store
 dd m_exit
 CENTRY `>body`, L8, 5
 dd m_literal
 dd 4
 dd m_plus
 dd m_exit
 CENTRY `aligned`, L9, 7
 dd m_literal
 dd 3
 dd m_plus
 dd m_literal
 dd -4
 dd m_binand
 dd m_exit
 CENTRY `cells`, L10, 5
 dd m_literal
 dd 2
 dd m_lshift
 dd m_exit
 CENTRY `cell+`, L11, 5
 dd m_literal
 dd 1
 dd L10
 dd m_plus
 dd m_exit
 CENTRY `depth`, L12, 5
 dd L4
 dd m_fetch
 dd m_stackptr
 dd m_minus
 dd m_literal
 dd 2
 dd m_rshift
 dd m_literal
 dd 1
 dd m_minus
 dd m_exit
 CENTRY `nip`, L13, 3
 dd m_xswap
 dd m_drop
 dd m_exit
 CENTRY `rot`, L14, 3
 dd m_rpush
 dd m_xswap
 dd m_rpop
 dd m_xswap
 dd m_exit
 CENTRY `2drop`, L15, 5
 dd m_drop
 dd m_drop
 dd m_exit
 CENTRY `2dup`, L16, 4
 dd m_over
 dd m_over
 dd m_exit
 CENTRY `2nip`, L17, 4
 dd L13
 dd L13
 dd m_exit
 CENTRY `2swap`, L18, 5
 dd L14
 dd m_rpush
 dd L14
 dd m_rpop
 dd m_exit
 CENTRY `?dup`, L19, 4
 dd m_dup
 dd m_dup
 dd m_literal
 dd 0
 dd m_equal
 dd m_cjump
 dd L20
 dd m_drop
L20:
 dd m_exit
 CENTRY `pick`, L21, 4
 dd L19
 dd m_cjump
 dd L22
 dd m_literal
 dd 1
 dd m_plus
 dd L10
 dd m_stackptr
 dd m_plus
 dd m_fetch
 dd m_jump
 dd L23
L22:
 dd m_dup
L23:
 dd m_exit
 CENTRY `tuck`, L24, 4
 dd m_dup
 dd m_rpush
 dd m_xswap
 dd m_rpop
 dd m_exit
 CENTRY `/`, L25, 1
 dd m_slashmod
 dd L13
 dd m_exit
 CENTRY `+!`, L26, 2
 dd m_dup
 dd m_fetch
 dd L14
 dd m_plus
 dd m_xswap
 dd m_store
 dd m_exit
 CENTRY `invert`, L27, 6
 dd m_literal
 dd -1
 dd m_binxor
 dd m_exit
 CENTRY `mod`, L28, 3
 dd m_slashmod
 dd m_drop
 dd m_exit
 CENTRY `1+`, L29, 2
 dd m_literal
 dd 1
 dd m_plus
 dd m_exit
 CENTRY `1-`, L30, 2
 dd m_literal
 dd 1
 dd m_minus
 dd m_exit
 CENTRY `negate`, L31, 6
 dd m_literal
 dd 0
 dd m_xswap
 dd m_minus
 dd m_exit
 CENTRY `2*`, L32, 2
 dd m_literal
 dd 1
 dd m_lshift
 dd m_exit
 CENTRY `2/`, L33, 2
 dd m_literal
 dd 1
 dd m_rshifta
 dd m_exit
 CENTRY `0=`, L34, 2
 dd m_literal
 dd 0
 dd m_equal
 dd m_exit
 CENTRY `0<`, L35, 2
 dd m_literal
 dd 0
 dd m_less
 dd m_exit
 CENTRY `0>`, L36, 2
 dd m_literal
 dd 0
 dd m_greater
 dd m_exit
 CENTRY `<>`, L37, 2
 dd m_equal
 dd L27
 dd m_exit
 CENTRY `0<>`, L38, 3
 dd m_literal
 dd 0
 dd L37
 dd m_exit
 CENTRY `max`, L39, 3
 dd L16
 dd m_greater
 dd m_cjump
 dd L40
 dd m_drop
 dd m_jump
 dd L41
L40:
 dd L13
L41:
 dd m_exit
 CENTRY `min`, L42, 3
 dd L16
 dd m_less
 dd m_cjump
 dd L43
 dd m_drop
 dd m_jump
 dd L44
L43:
 dd L13
L44:
 dd m_exit
 CENTRY `signum`, L45, 6
 dd m_dup
 dd L36
 dd m_cjump
 dd L46
 dd m_drop
 dd m_literal
 dd 1
 dd m_jump
 dd L47
L46:
 dd L35
 dd m_cjump
 dd L48
 dd m_literal
 dd -1
 dd m_jump
 dd L49
L48:
 dd m_literal
 dd 0
L49:
L47:
 dd m_exit
 CENTRY `within`, L50, 6
 dd m_rpush
 dd m_over
 dd m_greater
 dd L34
 dd m_xswap
 dd m_rpop
 dd m_greater
 dd L34
 dd m_binand
 dd m_exit
 CENTRY `abs`, L51, 3
 dd m_dup
 dd L35
 dd m_cjump
 dd L52
 dd L31
L52:
 dd m_exit
 CENTRY `count`, L53, 5
 dd L29
 dd m_dup
 dd L30
 dd m_cfetch
 dd m_exit
 CENTRY `compare`, L54, 7
 dd L14
 dd L16
 dd m_rpush
 dd m_rpush
 dd L42
 dd m_literal
 dd 0
 dd m_doinit
L55:
 dd m_over
 dd m_i
 dd m_plus
 dd m_cfetch
 dd m_over
 dd m_i
 dd m_plus
 dd m_cfetch
 dd m_minus
 dd L45
 dd L19
 dd m_cjump
 dd L56
 dd L17
 dd m_unloop
 dd m_unloop
 dd m_exit
L56:
 dd m_doloop
 dd L55
 dd L15
 dd m_rpop
 dd m_rpop
 dd m_minus
 dd L45
 dd m_exit
 CENTRY `erase`, L57, 5
 dd m_literal
 dd 0
 dd m_doinit
L58:
 dd m_literal
 dd 0
 dd m_over
 dd m_cstore
 dd L29
 dd m_doloop
 dd L58
 dd m_drop
 dd m_exit
 CENTRY `fill`, L59, 4
 dd m_xswap
 dd m_literal
 dd 0
 dd m_doinit
L60:
 dd L16
 dd m_xswap
 dd m_i
 dd m_plus
 dd m_cstore
 dd m_doloop
 dd L60
 dd L15
 dd m_exit
 CENTRY `blank`, L61, 5
 dd L3
 dd L59
 dd m_exit
 VENTRY `searchlen`, L62, 9
 CENTRY `search`, L63, 6
 dd L62
 dd m_store
 dd m_xswap
 dd m_dup
 dd m_rpush
 dd L62
 dd m_fetch
 dd m_minus
 dd L29
 dd m_literal
 dd 0
 dd m_doinit
L64:
 dd m_over
 dd m_i
 dd m_plus
 dd m_over
 dd L62
 dd m_fetch
 dd m_xswap
 dd L62
 dd m_fetch
 dd L54
 dd L34
 dd m_cjump
 dd L65
 dd m_drop
 dd m_i
 dd m_plus
 dd m_i
 dd m_unloop
 dd m_rpop
 dd m_xswap
 dd m_minus
 dd L2
 dd m_exit
L65:
 dd m_doloop
 dd L64
 dd m_drop
 dd m_rpop
 dd L1
 dd m_exit
 CENTRY `here`, L66, 4
 dd v_h
 dd m_fetch
 dd m_exit
 CENTRY `,`, L67, 1
 dd L66
 dd m_store
 dd m_literal
 dd 4
 dd v_h
 dd L26
 dd m_exit
 CENTRY `c,`, L68, 2
 dd L66
 dd m_cstore
 dd m_literal
 dd 1
 dd v_h
 dd L26
 dd m_exit
 CENTRY `allot`, L69, 5
 dd v_h
 dd L26
 dd m_exit
 CENTRY `pad`, L70, 3
 dd L66
 dd m_literal
 dd 256
 dd m_plus
 dd m_exit
 CENTRY `align`, L71, 5
 dd L66
 dd L9
 dd v_h
 dd m_store
 dd m_exit
 CENTRY `unused`, L72, 6
 dd v_heaptop
 dd m_fetch
 dd L66
 dd m_minus
 dd m_exit
 VENTRY `iobuf`, L73, 5
 VENTRY `stdin`, L74, 5
 VENTRY `stdout`, L75, 6
 VENTRY `eof`, L76, 3
 CENTRY `key`, L77, 3
 dd L73
 dd m_literal
 dd 1
 dd L74
 dd m_fetch
 dd m_fsread
 dd L34
 dd m_cjump
 dd L78
 dd L76
 dd L6
 dd m_literal
 dd -1
 dd m_jump
 dd L79
L78:
 dd L73
 dd m_cfetch
L79:
 dd m_exit
 CENTRY `emit`, L80, 4
 dd L73
 dd m_cstore
 dd L73
 dd m_literal
 dd 1
 dd L75
 dd m_fetch
 dd m_fswrite
 dd m_drop
 dd m_exit
 CENTRY `type`, L81, 4
 dd L75
 dd m_fetch
 dd m_fswrite
 dd m_drop
 dd m_exit
 CENTRY `cr`, L82, 2
 dd m_literal
 dd 10
 dd L80
 dd m_exit
 CENTRY `space`, L83, 5
 dd L3
 dd L80
 dd m_exit
 CENTRY `emits`, L84, 5
L85:
 dd L19
 dd m_cjump
 dd L86
 dd m_over
 dd L80
 dd L30
 dd m_jump
 dd L85
L86:
 dd m_drop
 dd m_exit
 CENTRY `spaces`, L87, 6
 dd L3
 dd m_xswap
 dd L84
 dd m_exit
 VENTRY `base`, L88, 4
 VENTRY `>num`, L89, 4
 CENTRY `<#`, L90, 2
 dd L70
 dd m_literal
 dd 1024
 dd m_plus
 dd L89
 dd m_store
 dd m_exit
 CENTRY `#`, L91, 1
 dd L88
 dd m_fetch
 dd m_uslashmod
 dd m_xswap
 dd m_dup
 dd m_literal
 dd 9
 dd m_greater
 dd m_cjump
 dd L92
 dd m_literal
 dd 97
 dd m_plus
 dd m_literal
 dd 10
 dd m_minus
 dd m_jump
 dd L93
L92:
 dd m_literal
 dd 48
 dd m_plus
L93:
 dd L89
 dd m_fetch
 dd L30
 dd m_dup
 dd L89
 dd m_store
 dd m_cstore
 dd m_exit
 CENTRY `#s`, L94, 2
L95:
 dd L91
 dd m_dup
 dd m_cjump
 dd L96
 dd m_jump
 dd L95
L96:
 dd m_exit
 CENTRY `#>`, L97, 2
 dd m_drop
 dd L89
 dd m_fetch
 dd m_dup
 dd L70
 dd m_literal
 dd 1024
 dd m_plus
 dd m_xswap
 dd m_minus
 dd m_exit
 CENTRY `hold`, L98, 4
 dd L89
 dd m_fetch
 dd L30
 dd m_dup
 dd m_rpush
 dd m_cstore
 dd m_rpop
 dd L89
 dd m_store
 dd m_exit
 CENTRY `sign`, L99, 4
 dd L35
 dd m_cjump
 dd L100
 dd m_literal
 dd 45
 dd L98
L100:
 dd m_exit
 CENTRY `.`, L101, 1
 dd m_dup
 dd L51
 dd L90
 dd L94
 dd m_xswap
 dd L99
 dd L97
 dd L81
 dd L83
 dd m_exit
 CENTRY `.r`, L102, 2
 dd m_rpush
 dd m_dup
 dd L51
 dd L90
 dd L94
 dd m_xswap
 dd L99
 dd L97
 dd m_rpop
 dd m_over
 dd m_minus
 dd m_literal
 dd 0
 dd L39
 dd L87
 dd L81
 dd m_exit
 CENTRY `hex`, L103, 3
 dd m_literal
 dd 16
 dd L88
 dd m_store
 dd m_exit
 CENTRY `decimal`, L104, 7
 dd m_literal
 dd 10
 dd L88
 dd m_store
 dd m_exit
 CENTRY `digit`, L105, 5
 dd m_dup
 dd m_literal
 dd 65
 dd m_literal
 dd 91
 dd L50
 dd m_cjump
 dd L106
 dd m_literal
 dd 55
 dd m_minus
 dd m_jump
 dd L107
L106:
 dd m_dup
 dd m_literal
 dd 97
 dd m_literal
 dd 123
 dd L50
 dd m_cjump
 dd L108
 dd m_literal
 dd 87
 dd m_minus
 dd m_jump
 dd L109
L108:
 dd m_dup
 dd m_literal
 dd 48
 dd m_literal
 dd 58
 dd L50
 dd m_cjump
 dd L110
 dd m_literal
 dd 48
 dd m_minus
 dd m_jump
 dd L111
L110:
 dd m_drop
 dd L1
 dd m_exit
L111:
L109:
L107:
 dd m_dup
 dd L88
 dd m_fetch
 dd m_less
 dd m_cjump
 dd L112
 dd L2
 dd m_jump
 dd L113
L112:
 dd m_drop
 dd L1
L113:
 dd m_exit
 CENTRY `number`, L114, 6
 dd m_xswap
 dd m_dup
 dd m_cfetch
 dd m_literal
 dd 45
 dd m_equal
 dd m_cjump
 dd L115
 dd L29
 dd m_xswap
 dd L30
 dd m_literal
 dd -1
 dd m_rpush
 dd m_jump
 dd L116
L115:
 dd m_xswap
 dd m_literal
 dd 1
 dd m_rpush
L116:
 dd m_dup
 dd m_rpush
 dd m_literal
 dd 0
 dd m_xswap
 dd m_literal
 dd 0
 dd m_doinit
L117:
 dd L88
 dd m_fetch
 dd m_multiply
 dd m_over
 dd m_i
 dd m_plus
 dd m_cfetch
 dd L105
 dd m_cjump
 dd L118
 dd m_plus
 dd m_jump
 dd L119
L118:
 dd m_drop
 dd m_unloop
 dd m_rpop
 dd m_rpop
 dd m_drop
 dd L1
 dd m_exit
L119:
 dd m_doloop
 dd L117
 dd m_rpop
 dd m_drop
 dd L13
 dd m_rpop
 dd m_multiply
 dd L2
 dd m_exit
 VENTRY `>in`, L120, 3
 VENTRY `>limit`, L121, 6
 VENTRY `wordbuf`, L122, 7
 VENTRY `abortvec`, L123, 8
 VENTRY `findadr`, L124, 7
 VENTRY `sourcebuf`, L125, 9
 VENTRY `blk`, L126, 3
 CENTRY `abort`, L127, 5
 dd L123
 dd m_fetch
 dd m_execute
 dd m_exit
 CENTRY `source`, L128, 6
 dd L125
 dd m_fetch
 dd m_exit
 CENTRY `current-input`, L129, 13
 dd L120
 dd m_fetch
 dd L128
 dd m_plus
 dd m_cfetch
 dd m_exit
 CENTRY `save-input`, L130, 10
 dd L74
 dd m_fetch
 dd L120
 dd m_fetch
 dd L121
 dd m_fetch
 dd L125
 dd m_fetch
 dd L126
 dd m_fetch
 dd m_literal
 dd 5
 dd m_exit
 CENTRY `default-input`, L131, 13
 dd L74
 dd L7
 dd L120
 dd L7
 dd L121
 dd L7
 dd v_tib
 dd L125
 dd m_store
 dd L126
 dd L7
 dd m_exit
 CENTRY `restore-input`, L132, 13
 dd L76
 dd L7
 dd m_literal
 dd 5
 dd L37
 dd m_cjump
 dd L133
 dd L131
 dd L1
 dd m_jump
 dd L134
L133:
 dd L126
 dd m_store
 dd L125
 dd m_store
 dd L121
 dd m_store
 dd L120
 dd m_store
 dd L74
 dd m_store
 dd L2
L134:
 dd m_exit
 CENTRY `?restore-input`, L135, 14
 dd L132
 dd L34
 dd m_cjump
 dd L136
 dd L83
 dd m_literal
 dd L137
 dd m_literal
 dd 23
 dd L81
 dd L82
 dd L127
L136:
 dd m_exit
 CENTRY `next-input`, L138, 10
 dd L120
 dd m_fetch
 dd L121
 dd m_fetch
 dd m_less
 dd m_cjump
 dd L139
 dd L2
 dd L129
 dd m_jump
 dd L140
L139:
 dd m_literal
 dd 0
 dd L1
L140:
 dd m_exit
 CENTRY `parse`, L141, 5
 dd m_rpush
 dd L122
 dd m_fetch
 dd L29
L142:
 dd L138
 dd m_rfetch
 dd L37
 dd m_binand
 dd m_cjump
 dd L143
 dd L129
 dd m_over
 dd m_cstore
 dd L29
 dd m_literal
 dd 1
 dd L120
 dd L26
 dd m_jump
 dd L142
L143:
 dd m_literal
 dd 1
 dd L120
 dd L26
 dd m_rpop
 dd m_drop
 dd L122
 dd m_fetch
 dd m_dup
 dd m_rpush
 dd m_minus
 dd L30
 dd m_rfetch
 dd m_cstore
 dd m_rpop
 dd m_exit
 CENTRY `word`, L144, 4
 dd m_rpush
L145:
 dd L138
 dd m_rfetch
 dd m_equal
 dd m_binand
 dd m_cjump
 dd L146
 dd m_literal
 dd 1
 dd L120
 dd L26
 dd m_jump
 dd L145
L146:
 dd m_rpop
 dd L141
 dd m_exit
 CENTRY `accept`, L147, 6
 dd m_xswap
 dd m_dup
 dd m_rpush
 dd m_rpush
L148:
 dd L19
 dd m_cjump
 dd L149
 dd L77
 dd m_dup
 dd m_literal
 dd 10
 dd m_equal
 dd m_over
 dd m_literal
 dd -1
 dd m_equal
 dd m_binor
 dd m_cjump
 dd L150
 dd L15
 dd m_rpop
 dd m_rpop
 dd m_minus
 dd m_exit
L150:
 dd m_rfetch
 dd m_cstore
 dd m_rpop
 dd L29
 dd m_rpush
 dd L30
 dd m_jump
 dd L148
L149:
 dd m_rpop
 dd m_rpop
 dd m_minus
 dd m_exit
 CENTRY `query`, L151, 5
 dd L76
 dd L7
 dd v_tib
 dd m_literal
 dd 1024
 dd L147
 dd m_dup
 dd L34
 dd L76
 dd m_fetch
 dd m_binand
 dd m_cjump
 dd L152
 dd m_drop
 dd L135
 dd m_jump
 dd L153
L152:
 dd L121
 dd m_store
 dd L120
 dd L7
L153:
 dd m_exit
 CENTRY `refill`, L154, 6
 dd L126
 dd m_fetch
 dd m_cjump
 dd L155
 dd L1
 dd m_jump
 dd L156
L155:
 dd L151
 dd L2
L156:
 dd m_exit
 CENTRY `findname`, L157, 8
 dd L124
 dd m_store
 dd v_dp
 dd m_fetch
L158:
 dd L19
 dd m_cjump
 dd L159
 dd m_dup
 dd L11
 dd m_cfetch
 dd m_literal
 dd 64
 dd m_binand
 dd m_cjump
 dd L160
 dd m_fetch
 dd m_jump
 dd L161
L160:
 dd m_dup
 dd L11
 dd L53
 dd m_literal
 dd 63
 dd m_binand
 dd L124
 dd m_fetch
 dd L53
 dd L54
 dd L34
 dd m_cjump
 dd L162
 dd L11
 dd L2
 dd m_exit
L162:
 dd m_fetch
L161:
 dd m_jump
 dd L158
L159:
 dd L124
 dd m_fetch
 dd L1
 dd m_exit
 CENTRY `find`, L163, 4
 dd L157
 dd m_cjump
 dd L164
 dd m_dup
 dd m_cfetch
 dd m_xswap
 dd m_over
 dd m_literal
 dd 63
 dd m_binand
 dd m_plus
 dd L29
 dd L9
 dd m_xswap
 dd m_literal
 dd 128
 dd m_binand
 dd m_cjump
 dd L165
 dd m_literal
 dd 1
 dd m_jump
 dd L166
L165:
 dd m_literal
 dd -1
L166:
 dd m_exit
 dd m_jump
 dd L167
L164:
 dd L1
L167:
 dd m_exit
 CENTRY `'`, L168, 1
 dd L3
 dd L144
 dd L163
 dd L34
 dd m_cjump
 dd L169
 dd L83
 dd L53
 dd L81
 dd m_literal
 dd L170
 dd m_literal
 dd 2
 dd L81
 dd L82
 dd L127
L169:
 dd m_exit
 CENTRY `?stack`, L171, 6
 dd m_stackptr
 dd L4
 dd m_fetch
 dd m_greater
 dd m_cjump
 dd L172
 dd m_literal
 dd L173
 dd m_literal
 dd 16
 dd L81
 dd L82
 dd L127
L172:
 dd m_exit
 CENTRY `interpret`, L174, 9
L175:
 dd L3
 dd L144
 dd m_dup
 dd m_cfetch
 dd L38
 dd m_cjump
 dd L176
 dd L163
 dd m_cjump
 dd L177
 dd m_execute
 dd L171
 dd m_jump
 dd L178
L177:
 dd L53
 dd L114
 dd L34
 dd m_cjump
 dd L179
 dd L83
 dd L81
 dd m_literal
 dd L180
 dd m_literal
 dd 2
 dd L81
 dd L82
 dd L127
L179:
L178:
 dd m_jump
 dd L175
L176:
 dd m_drop
 dd m_exit
 CENTRY `create`, L181, 6
 dd L71
 dd L66
 dd m_rpush
 dd v_dp
 dd m_fetch
 dd L67
 dd L3
 dd L144
 dd m_dup
 dd m_cfetch
 dd L66
 dd m_xswap
 dd L29
 dd m_dup
 dd m_rpush
 dd m_cmove
 dd m_rpop
 dd L69
 dd L71
 dd m_literal
 dd m_variable
 dd m_fetch
 dd L67
 dd m_rpop
 dd v_dp
 dd m_store
 dd m_exit
 CENTRY `variable`, L182, 8
 dd L181
 dd m_literal
 dd 0
 dd L67
 dd m_exit
 CENTRY `constant`, L183, 8
 dd L181
 dd m_literal
 dd m_constant
 dd m_fetch
 dd L66
 dd m_literal
 dd 1
 dd L10
 dd m_minus
 dd m_store
 dd L67
 dd m_exit
 VENTRY `state`, L184, 5
 CENTRY `immediate`, L185, 9
 dd v_dp
 dd m_fetch
 dd L11
 dd m_dup
 dd m_cfetch
 dd m_literal
 dd 128
 dd m_binor
 dd m_xswap
 dd m_cstore
 dd m_exit
 CENTRY `>cfa`, L186, 4
 dd L53
 dd m_literal
 dd 63
 dd m_binand
 dd m_plus
 dd L9
 dd m_exit
 CENTRY `compile`, L187, 7
 dd L157
 dd m_cjump
 dd L188
 dd m_dup
 dd m_cfetch
 dd m_literal
 dd 128
 dd m_binand
 dd m_cjump
 dd L189
 dd L186
 dd m_execute
 dd L171
 dd m_jump
 dd L190
L189:
 dd L186
 dd L67
L190:
 dd m_jump
 dd L191
L188:
 dd L53
 dd L114
 dd L34
 dd m_cjump
 dd L192
 dd L83
 dd L81
 dd m_literal
 dd L193
 dd m_literal
 dd 2
 dd L81
 dd L82
 dd L127
 dd m_jump
 dd L194
L192:
 dd m_literal
 dd m_literal
 dd L67
 dd L67
L194:
L191:
 dd m_exit
 CENTRY `]`, L195, 1
 dd L184
 dd L6
L196:
 dd L3
 dd L144
 dd m_dup
 dd m_cfetch
 dd L34
 dd m_cjump
 dd L197
 dd m_drop
 dd L154
 dd m_jump
 dd L198
L197:
 dd L187
 dd L184
 dd m_fetch
L198:
 dd m_cjump
 dd L199
 dd m_jump
 dd L196
L199:
 dd m_exit
 CIENTRY `[`, L200, 1
 dd L184
 dd L7
 dd m_exit
 CENTRY `smudge`, L201, 6
 dd v_dp
 dd m_fetch
 dd L11
 dd m_dup
 dd m_cfetch
 dd m_literal
 dd 64
 dd m_binor
 dd m_xswap
 dd m_cstore
 dd m_exit
 CENTRY `reveal`, L202, 6
 dd v_dp
 dd m_fetch
 dd L11
 dd m_dup
 dd m_cfetch
 dd m_literal
 dd 64
 dd L27
 dd m_binand
 dd m_xswap
 dd m_cstore
 dd m_exit
 CENTRY `:`, L203, 1
 dd L181
 dd L201
 dd m_literal
 dd m_colon
 dd m_fetch
 dd L66
 dd m_literal
 dd 1
 dd L10
 dd m_minus
 dd m_store
 dd L195
 dd m_exit
 CIENTRY `;`, L204, 1
 dd m_literal
 dd m_exit
 dd L67
 dd L184
 dd L7
 dd L202
 dd m_exit
 CIENTRY `recurse`, L205, 7
 dd v_dp
 dd m_fetch
 dd L11
 dd L186
 dd L67
 dd m_exit
 CENTRY `char`, L206, 4
 dd L3
 dd L144
 dd L29
 dd m_cfetch
 dd m_exit
 CENTRY `literal`, L207, 7
 dd m_literal
 dd m_literal
 dd L67
 dd L67
 dd m_exit
 CENTRY `sliteral`, L208, 8
 dd m_literal
 dd m_sliteral
 dd L67
 dd L66
 dd m_literal
 dd 34
 dd L141
 dd m_dup
 dd m_cfetch
 dd L29
 dd m_rpush
 dd m_xswap
 dd m_rfetch
 dd m_cmove
 dd m_rpop
 dd L69
 dd L71
 dd m_exit
 CENTRY `string`, L209, 6
 dd L144
 dd m_dup
 dd m_cfetch
 dd L29
 dd m_rpush
 dd L66
 dd m_rfetch
 dd m_cmove
 dd m_rpop
 dd L69
 dd m_exit
 CIENTRY `[char]`, L210, 6
 dd L3
 dd L144
 dd L29
 dd m_cfetch
 dd L207
 dd m_exit
 CIENTRY `[']`, L211, 3
 dd L168
 dd L207
 dd m_exit
 CIENTRY `(`, L212, 1
 dd m_literal
 dd 41
 dd L141
 dd m_drop
 dd m_exit
 CIENTRY '\', L213, 1
 dd L126
 dd m_fetch
 dd m_cjump
 dd L214
 dd L120
 dd m_fetch
 dd m_literal
 dd 63
 dd m_plus
 dd m_literal
 dd 63
 dd L27
 dd m_binand
 dd L120
 dd m_store
 dd m_jump
 dd L215
L214:
 dd L121
 dd m_fetch
 dd L120
 dd m_store
L215:
 dd m_exit
 CENTRY `(?abort)`, L216, 8
 dd L14
 dd m_cjump
 dd L217
 dd L83
 dd L81
 dd L82
 dd L127
 dd m_jump
 dd L218
L217:
 dd L15
L218:
 dd m_exit
 CIENTRY `abort"`, L219, 6
 dd L208
 dd m_literal
 dd L216
 dd L67
 dd m_exit
 CENTRY `"`, L220, 1
 dd m_literal
 dd 34
 dd L144
 dd L53
 dd m_rpush
 dd L66
 dd m_rfetch
 dd m_cmove
 dd L66
 dd m_rpop
 dd m_dup
 dd L69
 dd m_exit
 CENTRY `c"`, L221, 2
 dd m_literal
 dd 34
 dd L144
 dd m_dup
 dd m_cfetch
 dd L29
 dd m_rpush
 dd L66
 dd m_rfetch
 dd m_cmove
 dd L66
 dd m_rpop
 dd L69
 dd m_exit
 CIENTRY `s"`, L222, 2
 dd L208
 dd m_exit
 CIENTRY `."`, L223, 2
 dd L208
 dd m_literal
 dd L81
 dd L67
 dd m_exit
 CIENTRY `if`, L224, 2
 dd m_literal
 dd m_cjump
 dd L67
 dd L66
 dd m_literal
 dd 0
 dd L67
 dd m_exit
 CIENTRY `else`, L225, 4
 dd m_literal
 dd m_jump
 dd L67
 dd L66
 dd m_rpush
 dd m_literal
 dd 0
 dd L67
 dd L66
 dd m_xswap
 dd m_store
 dd m_rpop
 dd m_exit
 CIENTRY `then`, L226, 4
 dd L66
 dd m_xswap
 dd m_store
 dd m_exit
 CIENTRY `begin`, L227, 5
 dd L66
 dd m_exit
 CIENTRY `again`, L228, 5
 dd m_literal
 dd m_jump
 dd L67
 dd L67
 dd m_exit
 CIENTRY `until`, L229, 5
 dd m_literal
 dd m_cjump
 dd L67
 dd L67
 dd m_exit
 CIENTRY `while`, L230, 5
 dd m_literal
 dd m_cjump
 dd L67
 dd L66
 dd m_literal
 dd 0
 dd L67
 dd m_exit
 CIENTRY `repeat`, L231, 6
 dd m_literal
 dd m_jump
 dd L67
 dd m_xswap
 dd L67
 dd L66
 dd m_xswap
 dd m_store
 dd m_exit
 CIENTRY `do`, L232, 2
 dd m_literal
 dd m_doinit
 dd L67
 dd m_literal
 dd 0
 dd L66
 dd m_exit
 CIENTRY `loop`, L233, 4
 dd m_literal
 dd m_doloop
 dd L67
 dd L67
 dd L19
 dd m_cjump
 dd L234
 dd L66
 dd m_xswap
 dd m_store
L234:
 dd m_exit
 CIENTRY `+loop`, L235, 5
 dd m_literal
 dd m_doploop
 dd L67
 dd L67
 dd L19
 dd m_cjump
 dd L236
 dd L66
 dd m_xswap
 dd m_store
L236:
 dd m_exit
 CENTRY `w/o`, L237, 3
 dd m_literal
 dd 1
 dd m_literal
 dd 512
 dd m_binor
 dd m_literal
 dd 64
 dd m_binor
 dd m_exit
 CENTRY `r/o`, L238, 3
 dd m_literal
 dd 0
 dd m_exit
 CENTRY `r/w`, L239, 3
 dd m_literal
 dd 2
 dd m_exit
 CENTRY `open-file`, L240, 9
 dd m_rpush
 dd L70
 dd m_literal
 dd 1024
 dd m_plus
 dd m_xswap
 dd m_dup
 dd m_rpush
 dd m_cmove
 dd m_literal
 dd 0
 dd m_rpop
 dd L70
 dd m_plus
 dd m_literal
 dd 1024
 dd m_plus
 dd m_cstore
 dd L70
 dd m_literal
 dd 1024
 dd m_plus
 dd m_rpop
 dd m_literal
 dd 420
 dd m_fsopen
 dd m_dup
 dd m_literal
 dd -1
 dd m_greater
 dd m_exit
 CENTRY `close-file`, L241, 10
 dd m_fsclose
 dd L34
 dd m_exit
 CENTRY `read-file`, L242, 9
 dd m_fsread
 dd m_dup
 dd m_literal
 dd -1
 dd L37
 dd m_exit
 CENTRY `write-file`, L243, 10
 dd m_fswrite
 dd m_literal
 dd -1
 dd L37
 dd m_exit
 CENTRY `reposition-file`, L244, 15
 dd m_fsseek
 dd m_literal
 dd -1
 dd L37
 dd m_exit
 CENTRY `?fcheck`, L245, 7
 dd L34
 dd m_cjump
 dd L246
 dd L83
 dd m_literal
 dd L247
 dd m_literal
 dd 9
 dd L81
 dd L82
 dd L127
L246:
 dd m_exit
 CENTRY `bye`, L248, 3
 dd m_literal
 dd 0
 dd m_terminate
 dd m_exit
 CENTRY `include`, L249, 7
 dd L3
 dd L144
 dd m_rpush
 dd L121
 dd m_fetch
 dd L120
 dd m_store
 dd L130
 dd m_rpop
 dd L53
 dd L238
 dd L240
 dd L245
 dd L74
 dd m_store
 dd m_exit
 CENTRY `crash`, L250, 5
 dd m_literal
 dd L251
 dd m_literal
 dd 30
 dd L81
 dd L82
 dd L127
 dd m_exit
 CENTRY `quit`, L252, 4
 dd m_reset
 dd m_clear
L253:
 dd L151
 dd L174
 dd L74
 dd m_fetch
 dd L34
 dd m_cjump
 dd L254
 dd m_literal
 dd L255
 dd m_literal
 dd 3
 dd L81
 dd L82
L254:
 dd m_jump
 dd L253
 dd m_exit
 CENTRY `(abort)`, L256, 7
 dd L184
 dd L7
 dd v_tib
 dd L125
 dd m_store
 dd L126
 dd L7
 dd L74
 dd L7
 dd m_literal
 dd 1
 dd L75
 dd m_store
 dd L252
 dd m_exit
 CENTRY `boot`, L257, 4
 dd m_reset
 dd m_clear
 dd m_stackptr
 dd L4
 dd m_store
 dd v_heaptop
 dd m_fetch
 dd m_literal
 dd 1
 dd L10
 dd m_minus
 dd m_fetch
 dd L5
 dd m_store
 dd m_literal
 dd L256
 dd L123
 dd m_store
 dd v_tib
 dd m_literal
 dd 1024
 dd m_plus
 dd L122
 dd m_store
 dd v_tib
 dd L125
 dd m_store
 dd m_literal
 dd 0
 dd L74
 dd m_store
 dd m_literal
 dd 1
 dd L75
 dd m_store
 dd L184
 dd L7
 dd L104
 dd L252
 dd m_exit
L137:
 db 'unable to restore input'
L170:
 db ' ?'
L173:
 db ' stack underflow'
L180:
 db ' ?'
L193:
 db ' ?'
L247:
 db 'I/O error'
L251:
 db 'uninitialized execution vector'
L255:
 db ' ok'
