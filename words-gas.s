 CENTRY "false", L1, 5
 .word m_literal
 .word 0
 .word m_exit
 CENTRY "true", L2, 4
 .word m_literal
 .word -1
 .word m_exit
 CENTRY "bl", L3, 2
 .word m_literal
 .word 32
 .word m_exit
 VENTRY "s0", L4, 2
 VENTRY "args", L5, 4
 CENTRY "on", L6, 2
 .word m_literal
 .word -1
 .word m_xswap
 .word m_store
 .word m_exit
 CENTRY "off", L7, 3
 .word m_literal
 .word 0
 .word m_xswap
 .word m_store
 .word m_exit
 CENTRY ">body", L8, 5
 .word m_literal
 .word 4
 .word m_plus
 .word m_exit
 CENTRY "aligned", L9, 7
 .word m_literal
 .word 3
 .word m_plus
 .word m_literal
 .word -4
 .word m_binand
 .word m_exit
 CENTRY "cells", L10, 5
 .word m_literal
 .word 2
 .word m_lshift
 .word m_exit
 CENTRY "cell+", L11, 5
 .word m_literal
 .word 1
 .word L10
 .word m_plus
 .word m_exit
 CENTRY "depth", L12, 5
 .word L4
 .word m_fetch
 .word m_stackptr
 .word m_minus
 .word m_literal
 .word 2
 .word m_rshift
 .word m_literal
 .word 1
 .word m_minus
 .word m_exit
 CENTRY "nip", L13, 3
 .word m_xswap
 .word m_drop
 .word m_exit
 CENTRY "rot", L14, 3
 .word m_rpush
 .word m_xswap
 .word m_rpop
 .word m_xswap
 .word m_exit
 CENTRY "2drop", L15, 5
 .word m_drop
 .word m_drop
 .word m_exit
 CENTRY "2dup", L16, 4
 .word m_over
 .word m_over
 .word m_exit
 CENTRY "2nip", L17, 4
 .word L13
 .word L13
 .word m_exit
 CENTRY "2swap", L18, 5
 .word L14
 .word m_rpush
 .word L14
 .word m_rpop
 .word m_exit
 CENTRY "?dup", L19, 4
 .word m_dup
 .word m_dup
 .word m_literal
 .word 0
 .word m_equal
 .word m_cjump
 .word L20
 .word m_drop
L20:
 .word m_exit
 CENTRY "pick", L21, 4
 .word L19
 .word m_cjump
 .word L22
 .word m_literal
 .word 1
 .word m_plus
 .word L10
 .word m_stackptr
 .word m_plus
 .word m_fetch
 .word m_jump
 .word L23
L22:
 .word m_dup
L23:
 .word m_exit
 CENTRY "tuck", L24, 4
 .word m_dup
 .word m_rpush
 .word m_xswap
 .word m_rpop
 .word m_exit
 CENTRY "/", L25, 1
 .word m_slashmod
 .word L13
 .word m_exit
 CENTRY "+!", L26, 2
 .word m_dup
 .word m_fetch
 .word L14
 .word m_plus
 .word m_xswap
 .word m_store
 .word m_exit
 CENTRY "invert", L27, 6
 .word m_literal
 .word -1
 .word m_binxor
 .word m_exit
 CENTRY "mod", L28, 3
 .word m_slashmod
 .word m_drop
 .word m_exit
 CENTRY "1+", L29, 2
 .word m_literal
 .word 1
 .word m_plus
 .word m_exit
 CENTRY "1-", L30, 2
 .word m_literal
 .word 1
 .word m_minus
 .word m_exit
 CENTRY "negate", L31, 6
 .word m_literal
 .word 0
 .word m_xswap
 .word m_minus
 .word m_exit
 CENTRY "2*", L32, 2
 .word m_literal
 .word 1
 .word m_lshift
 .word m_exit
 CENTRY "2/", L33, 2
 .word m_literal
 .word 1
 .word m_rshifta
 .word m_exit
 CENTRY "0=", L34, 2
 .word m_literal
 .word 0
 .word m_equal
 .word m_exit
 CENTRY "0<", L35, 2
 .word m_literal
 .word 0
 .word m_less
 .word m_exit
 CENTRY "0>", L36, 2
 .word m_literal
 .word 0
 .word m_greater
 .word m_exit
 CENTRY "<>", L37, 2
 .word m_equal
 .word L27
 .word m_exit
 CENTRY "0<>", L38, 3
 .word m_literal
 .word 0
 .word L37
 .word m_exit
 CENTRY "max", L39, 3
 .word L16
 .word m_greater
 .word m_cjump
 .word L40
 .word m_drop
 .word m_jump
 .word L41
L40:
 .word L13
L41:
 .word m_exit
 CENTRY "min", L42, 3
 .word L16
 .word m_less
 .word m_cjump
 .word L43
 .word m_drop
 .word m_jump
 .word L44
L43:
 .word L13
L44:
 .word m_exit
 CENTRY "signum", L45, 6
 .word m_dup
 .word L36
 .word m_cjump
 .word L46
 .word m_drop
 .word m_literal
 .word 1
 .word m_jump
 .word L47
L46:
 .word L35
 .word m_cjump
 .word L48
 .word m_literal
 .word -1
 .word m_jump
 .word L49
L48:
 .word m_literal
 .word 0
L49:
L47:
 .word m_exit
 CENTRY "within", L50, 6
 .word m_rpush
 .word m_over
 .word m_greater
 .word L34
 .word m_xswap
 .word m_rpop
 .word m_greater
 .word L34
 .word m_binand
 .word m_exit
 CENTRY "abs", L51, 3
 .word m_dup
 .word L35
 .word m_cjump
 .word L52
 .word L31
L52:
 .word m_exit
 CENTRY "count", L53, 5
 .word L29
 .word m_dup
 .word L30
 .word m_cfetch
 .word m_exit
 CENTRY "compare", L54, 7
 .word L14
 .word L16
 .word m_rpush
 .word m_rpush
 .word L42
 .word m_literal
 .word 0
 .word m_doinit
L55:
 .word m_over
 .word m_i
 .word m_plus
 .word m_cfetch
 .word m_over
 .word m_i
 .word m_plus
 .word m_cfetch
 .word m_minus
 .word L45
 .word L19
 .word m_cjump
 .word L56
 .word L17
 .word m_unloop
 .word m_unloop
 .word m_exit
L56:
 .word m_doloop
 .word L55
 .word L15
 .word m_rpop
 .word m_rpop
 .word m_minus
 .word L45
 .word m_exit
 CENTRY "erase", L57, 5
 .word m_literal
 .word 0
 .word m_doinit
L58:
 .word m_literal
 .word 0
 .word m_over
 .word m_cstore
 .word L29
 .word m_doloop
 .word L58
 .word m_drop
 .word m_exit
 CENTRY "fill", L59, 4
 .word m_xswap
 .word m_literal
 .word 0
 .word m_doinit
L60:
 .word L16
 .word m_xswap
 .word m_i
 .word m_plus
 .word m_cstore
 .word m_doloop
 .word L60
 .word L15
 .word m_exit
 CENTRY "blank", L61, 5
 .word L3
 .word L59
 .word m_exit
 VENTRY "searchlen", L62, 9
 CENTRY "search", L63, 6
 .word L62
 .word m_store
 .word m_xswap
 .word m_dup
 .word m_rpush
 .word L62
 .word m_fetch
 .word m_minus
 .word L29
 .word m_literal
 .word 0
 .word m_doinit
L64:
 .word m_over
 .word m_i
 .word m_plus
 .word m_over
 .word L62
 .word m_fetch
 .word m_xswap
 .word L62
 .word m_fetch
 .word L54
 .word L34
 .word m_cjump
 .word L65
 .word m_drop
 .word m_i
 .word m_plus
 .word m_i
 .word m_unloop
 .word m_rpop
 .word m_xswap
 .word m_minus
 .word L2
 .word m_exit
L65:
 .word m_doloop
 .word L64
 .word m_drop
 .word m_rpop
 .word L1
 .word m_exit
 CENTRY "here", L66, 4
 .word v_h
 .word m_fetch
 .word m_exit
 CENTRY ",", L67, 1
 .word L66
 .word m_store
 .word m_literal
 .word 4
 .word v_h
 .word L26
 .word m_exit
 CENTRY "c,", L68, 2
 .word L66
 .word m_cstore
 .word m_literal
 .word 1
 .word v_h
 .word L26
 .word m_exit
 CENTRY "allot", L69, 5
 .word v_h
 .word L26
 .word m_exit
 CENTRY "pad", L70, 3
 .word L66
 .word m_literal
 .word 256
 .word m_plus
 .word m_exit
 CENTRY "align", L71, 5
 .word L66
 .word L9
 .word v_h
 .word m_store
 .word m_exit
 CENTRY "unused", L72, 6
 .word v_heaptop
 .word m_fetch
 .word L66
 .word m_minus
 .word m_exit
 VENTRY "iobuf", L73, 5
 VENTRY "stdin", L74, 5
 VENTRY "stdout", L75, 6
 VENTRY "eof", L76, 3
 CENTRY "key", L77, 3
 .word L73
 .word m_literal
 .word 1
 .word L74
 .word m_fetch
 .word m_fsread
 .word L34
 .word m_cjump
 .word L78
 .word L76
 .word L6
 .word m_literal
 .word -1
 .word m_jump
 .word L79
L78:
 .word L73
 .word m_cfetch
L79:
 .word m_exit
 CENTRY "emit", L80, 4
 .word L73
 .word m_cstore
 .word L73
 .word m_literal
 .word 1
 .word L75
 .word m_fetch
 .word m_fswrite
 .word m_drop
 .word m_exit
 CENTRY "type", L81, 4
 .word L75
 .word m_fetch
 .word m_fswrite
 .word m_drop
 .word m_exit
 CENTRY "cr", L82, 2
 .word m_literal
 .word 10
 .word L80
 .word m_exit
 CENTRY "space", L83, 5
 .word L3
 .word L80
 .word m_exit
 CENTRY "emits", L84, 5
L85:
 .word L19
 .word m_cjump
 .word L86
 .word m_over
 .word L80
 .word L30
 .word m_jump
 .word L85
L86:
 .word m_drop
 .word m_exit
 CENTRY "spaces", L87, 6
 .word L3
 .word m_xswap
 .word L84
 .word m_exit
 VENTRY "base", L88, 4
 VENTRY ">num", L89, 4
 CENTRY "<#", L90, 2
 .word L70
 .word m_literal
 .word 1024
 .word m_plus
 .word L89
 .word m_store
 .word m_exit
 CENTRY "#", L91, 1
 .word L88
 .word m_fetch
 .word m_uslashmod
 .word m_xswap
 .word m_dup
 .word m_literal
 .word 9
 .word m_greater
 .word m_cjump
 .word L92
 .word m_literal
 .word 97
 .word m_plus
 .word m_literal
 .word 10
 .word m_minus
 .word m_jump
 .word L93
L92:
 .word m_literal
 .word 48
 .word m_plus
L93:
 .word L89
 .word m_fetch
 .word L30
 .word m_dup
 .word L89
 .word m_store
 .word m_cstore
 .word m_exit
 CENTRY "#s", L94, 2
L95:
 .word L91
 .word m_dup
 .word m_cjump
 .word L96
 .word m_jump
 .word L95
L96:
 .word m_exit
 CENTRY "#>", L97, 2
 .word m_drop
 .word L89
 .word m_fetch
 .word m_dup
 .word L70
 .word m_literal
 .word 1024
 .word m_plus
 .word m_xswap
 .word m_minus
 .word m_exit
 CENTRY "hold", L98, 4
 .word L89
 .word m_fetch
 .word L30
 .word m_dup
 .word m_rpush
 .word m_cstore
 .word m_rpop
 .word L89
 .word m_store
 .word m_exit
 CENTRY "sign", L99, 4
 .word L35
 .word m_cjump
 .word L100
 .word m_literal
 .word 45
 .word L98
L100:
 .word m_exit
 CENTRY ".", L101, 1
 .word m_dup
 .word L51
 .word L90
 .word L94
 .word m_xswap
 .word L99
 .word L97
 .word L81
 .word L83
 .word m_exit
 CENTRY ".r", L102, 2
 .word m_rpush
 .word m_dup
 .word L51
 .word L90
 .word L94
 .word m_xswap
 .word L99
 .word L97
 .word m_rpop
 .word m_over
 .word m_minus
 .word m_literal
 .word 0
 .word L39
 .word L87
 .word L81
 .word m_exit
 CENTRY "hex", L103, 3
 .word m_literal
 .word 16
 .word L88
 .word m_store
 .word m_exit
 CENTRY "decimal", L104, 7
 .word m_literal
 .word 10
 .word L88
 .word m_store
 .word m_exit
 CENTRY "digit", L105, 5
 .word m_dup
 .word m_literal
 .word 65
 .word m_literal
 .word 91
 .word L50
 .word m_cjump
 .word L106
 .word m_literal
 .word 55
 .word m_minus
 .word m_jump
 .word L107
L106:
 .word m_dup
 .word m_literal
 .word 97
 .word m_literal
 .word 123
 .word L50
 .word m_cjump
 .word L108
 .word m_literal
 .word 87
 .word m_minus
 .word m_jump
 .word L109
L108:
 .word m_dup
 .word m_literal
 .word 48
 .word m_literal
 .word 58
 .word L50
 .word m_cjump
 .word L110
 .word m_literal
 .word 48
 .word m_minus
 .word m_jump
 .word L111
L110:
 .word m_drop
 .word L1
 .word m_exit
L111:
L109:
L107:
 .word m_dup
 .word L88
 .word m_fetch
 .word m_less
 .word m_cjump
 .word L112
 .word L2
 .word m_jump
 .word L113
L112:
 .word m_drop
 .word L1
L113:
 .word m_exit
 CENTRY "number", L114, 6
 .word m_xswap
 .word m_dup
 .word m_cfetch
 .word m_literal
 .word 45
 .word m_equal
 .word m_cjump
 .word L115
 .word L29
 .word m_xswap
 .word L30
 .word m_literal
 .word -1
 .word m_rpush
 .word m_jump
 .word L116
L115:
 .word m_xswap
 .word m_literal
 .word 1
 .word m_rpush
L116:
 .word m_dup
 .word m_rpush
 .word m_literal
 .word 0
 .word m_xswap
 .word m_literal
 .word 0
 .word m_doinit
L117:
 .word L88
 .word m_fetch
 .word m_multiply
 .word m_over
 .word m_i
 .word m_plus
 .word m_cfetch
 .word L105
 .word m_cjump
 .word L118
 .word m_plus
 .word m_jump
 .word L119
L118:
 .word m_drop
 .word m_unloop
 .word m_rpop
 .word m_rpop
 .word m_drop
 .word L1
 .word m_exit
L119:
 .word m_doloop
 .word L117
 .word m_rpop
 .word m_drop
 .word L13
 .word m_rpop
 .word m_multiply
 .word L2
 .word m_exit
 VENTRY ">in", L120, 3
 VENTRY ">limit", L121, 6
 VENTRY "wordbuf", L122, 7
 VENTRY "abortvec", L123, 8
 VENTRY "findadr", L124, 7
 VENTRY "sourcebuf", L125, 9
 VENTRY "blk", L126, 3
 CENTRY "abort", L127, 5
 .word L123
 .word m_fetch
 .word m_execute
 .word m_exit
 CENTRY "source", L128, 6
 .word L125
 .word m_fetch
 .word m_exit
 CENTRY "current-input", L129, 13
 .word L120
 .word m_fetch
 .word L128
 .word m_plus
 .word m_cfetch
 .word m_exit
 CENTRY "save-input", L130, 10
 .word L74
 .word m_fetch
 .word L120
 .word m_fetch
 .word L121
 .word m_fetch
 .word L125
 .word m_fetch
 .word L126
 .word m_fetch
 .word m_literal
 .word 5
 .word m_exit
 CENTRY "default-input", L131, 13
 .word L74
 .word L7
 .word L120
 .word L7
 .word L121
 .word L7
 .word v_tib
 .word L125
 .word m_store
 .word L126
 .word L7
 .word m_exit
 CENTRY "restore-input", L132, 13
 .word L76
 .word L7
 .word m_literal
 .word 5
 .word L37
 .word m_cjump
 .word L133
 .word L131
 .word L1
 .word m_jump
 .word L134
L133:
 .word L126
 .word m_store
 .word L125
 .word m_store
 .word L121
 .word m_store
 .word L120
 .word m_store
 .word L74
 .word m_store
 .word L2
L134:
 .word m_exit
 CENTRY "?restore-input", L135, 14
 .word L132
 .word L34
 .word m_cjump
 .word L136
 .word L83
 .word m_literal
 .word L137
 .word m_literal
 .word 23
 .word L81
 .word L82
 .word L127
L136:
 .word m_exit
 CENTRY "next-input", L138, 10
 .word L120
 .word m_fetch
 .word L121
 .word m_fetch
 .word m_less
 .word m_cjump
 .word L139
 .word L2
 .word L129
 .word m_jump
 .word L140
L139:
 .word m_literal
 .word 0
 .word L1
L140:
 .word m_exit
 CENTRY "parse", L141, 5
 .word m_rpush
 .word L122
 .word m_fetch
 .word L29
L142:
 .word L138
 .word m_rfetch
 .word L37
 .word m_binand
 .word m_cjump
 .word L143
 .word L129
 .word m_over
 .word m_cstore
 .word L29
 .word m_literal
 .word 1
 .word L120
 .word L26
 .word m_jump
 .word L142
L143:
 .word m_literal
 .word 1
 .word L120
 .word L26
 .word m_rpop
 .word m_drop
 .word L122
 .word m_fetch
 .word m_dup
 .word m_rpush
 .word m_minus
 .word L30
 .word m_rfetch
 .word m_cstore
 .word m_rpop
 .word m_exit
 CENTRY "word", L144, 4
 .word m_rpush
L145:
 .word L138
 .word m_rfetch
 .word m_equal
 .word m_binand
 .word m_cjump
 .word L146
 .word m_literal
 .word 1
 .word L120
 .word L26
 .word m_jump
 .word L145
L146:
 .word m_rpop
 .word L141
 .word m_exit
 CENTRY "accept", L147, 6
 .word m_xswap
 .word m_dup
 .word m_rpush
 .word m_rpush
L148:
 .word L19
 .word m_cjump
 .word L149
 .word L77
 .word m_dup
 .word m_literal
 .word 10
 .word m_equal
 .word m_over
 .word m_literal
 .word -1
 .word m_equal
 .word m_binor
 .word m_cjump
 .word L150
 .word L15
 .word m_rpop
 .word m_rpop
 .word m_minus
 .word m_exit
L150:
 .word m_rfetch
 .word m_cstore
 .word m_rpop
 .word L29
 .word m_rpush
 .word L30
 .word m_jump
 .word L148
L149:
 .word m_rpop
 .word m_rpop
 .word m_minus
 .word m_exit
 CENTRY "query", L151, 5
 .word L76
 .word L7
 .word v_tib
 .word m_literal
 .word 1024
 .word L147
 .word m_dup
 .word L34
 .word L76
 .word m_fetch
 .word m_binand
 .word m_cjump
 .word L152
 .word m_drop
 .word L135
 .word m_jump
 .word L153
L152:
 .word L121
 .word m_store
 .word L120
 .word L7
L153:
 .word m_exit
 CENTRY "refill", L154, 6
 .word L126
 .word m_fetch
 .word m_cjump
 .word L155
 .word L1
 .word m_jump
 .word L156
L155:
 .word L151
 .word L2
L156:
 .word m_exit
 CENTRY "findname", L157, 8
 .word L124
 .word m_store
 .word v_dp
 .word m_fetch
L158:
 .word L19
 .word m_cjump
 .word L159
 .word m_dup
 .word L11
 .word m_cfetch
 .word m_literal
 .word 64
 .word m_binand
 .word m_cjump
 .word L160
 .word m_fetch
 .word m_jump
 .word L161
L160:
 .word m_dup
 .word L11
 .word L53
 .word m_literal
 .word 63
 .word m_binand
 .word L124
 .word m_fetch
 .word L53
 .word L54
 .word L34
 .word m_cjump
 .word L162
 .word L11
 .word L2
 .word m_exit
L162:
 .word m_fetch
L161:
 .word m_jump
 .word L158
L159:
 .word L124
 .word m_fetch
 .word L1
 .word m_exit
 CENTRY "find", L163, 4
 .word L157
 .word m_cjump
 .word L164
 .word m_dup
 .word m_cfetch
 .word m_xswap
 .word m_over
 .word m_literal
 .word 63
 .word m_binand
 .word m_plus
 .word L29
 .word L9
 .word m_xswap
 .word m_literal
 .word 128
 .word m_binand
 .word m_cjump
 .word L165
 .word m_literal
 .word 1
 .word m_jump
 .word L166
L165:
 .word m_literal
 .word -1
L166:
 .word m_exit
 .word m_jump
 .word L167
L164:
 .word L1
L167:
 .word m_exit
 CENTRY "'", L168, 1
 .word L3
 .word L144
 .word L163
 .word L34
 .word m_cjump
 .word L169
 .word L83
 .word L53
 .word L81
 .word m_literal
 .word L170
 .word m_literal
 .word 2
 .word L81
 .word L82
 .word L127
L169:
 .word m_exit
 CENTRY "?stack", L171, 6
 .word m_stackptr
 .word L4
 .word m_fetch
 .word m_greater
 .word m_cjump
 .word L172
 .word m_literal
 .word L173
 .word m_literal
 .word 16
 .word L81
 .word L82
 .word L127
L172:
 .word m_exit
 CENTRY "interpret", L174, 9
L175:
 .word L3
 .word L144
 .word m_dup
 .word m_cfetch
 .word L38
 .word m_cjump
 .word L176
 .word L163
 .word m_cjump
 .word L177
 .word m_execute
 .word L171
 .word m_jump
 .word L178
L177:
 .word L53
 .word L114
 .word L34
 .word m_cjump
 .word L179
 .word L83
 .word L81
 .word m_literal
 .word L180
 .word m_literal
 .word 2
 .word L81
 .word L82
 .word L127
L179:
L178:
 .word m_jump
 .word L175
L176:
 .word m_drop
 .word m_exit
 CENTRY "create", L181, 6
 .word L71
 .word L66
 .word m_rpush
 .word v_dp
 .word m_fetch
 .word L67
 .word L3
 .word L144
 .word m_dup
 .word m_cfetch
 .word L66
 .word m_xswap
 .word L29
 .word m_dup
 .word m_rpush
 .word m_cmove
 .word m_rpop
 .word L69
 .word L71
 .word m_literal
 .word m_variable
 .word m_fetch
 .word L67
 .word m_rpop
 .word v_dp
 .word m_store
 .word m_exit
 CENTRY "variable", L182, 8
 .word L181
 .word m_literal
 .word 0
 .word L67
 .word m_exit
 CENTRY "constant", L183, 8
 .word L181
 .word m_literal
 .word m_constant
 .word m_fetch
 .word L66
 .word m_literal
 .word 1
 .word L10
 .word m_minus
 .word m_store
 .word L67
 .word m_exit
 VENTRY "state", L184, 5
 CENTRY "immediate", L185, 9
 .word v_dp
 .word m_fetch
 .word L11
 .word m_dup
 .word m_cfetch
 .word m_literal
 .word 128
 .word m_binor
 .word m_xswap
 .word m_cstore
 .word m_exit
 CENTRY ">cfa", L186, 4
 .word L53
 .word m_literal
 .word 63
 .word m_binand
 .word m_plus
 .word L9
 .word m_exit
 CENTRY "compile", L187, 7
 .word L157
 .word m_cjump
 .word L188
 .word m_dup
 .word m_cfetch
 .word m_literal
 .word 128
 .word m_binand
 .word m_cjump
 .word L189
 .word L186
 .word m_execute
 .word L171
 .word m_jump
 .word L190
L189:
 .word L186
 .word L67
L190:
 .word m_jump
 .word L191
L188:
 .word L53
 .word L114
 .word L34
 .word m_cjump
 .word L192
 .word L83
 .word L81
 .word m_literal
 .word L193
 .word m_literal
 .word 2
 .word L81
 .word L82
 .word L127
 .word m_jump
 .word L194
L192:
 .word m_literal
 .word m_literal
 .word L67
 .word L67
L194:
L191:
 .word m_exit
 CENTRY "]", L195, 1
 .word L184
 .word L6
L196:
 .word L3
 .word L144
 .word m_dup
 .word m_cfetch
 .word L34
 .word m_cjump
 .word L197
 .word m_drop
 .word L154
 .word m_jump
 .word L198
L197:
 .word L187
 .word L184
 .word m_fetch
L198:
 .word m_cjump
 .word L199
 .word m_jump
 .word L196
L199:
 .word m_exit
 CIENTRY "[", L200, 1
 .word L184
 .word L7
 .word m_exit
 CENTRY "smudge", L201, 6
 .word v_dp
 .word m_fetch
 .word L11
 .word m_dup
 .word m_cfetch
 .word m_literal
 .word 64
 .word m_binor
 .word m_xswap
 .word m_cstore
 .word m_exit
 CENTRY "reveal", L202, 6
 .word v_dp
 .word m_fetch
 .word L11
 .word m_dup
 .word m_cfetch
 .word m_literal
 .word 64
 .word L27
 .word m_binand
 .word m_xswap
 .word m_cstore
 .word m_exit
 CENTRY ":", L203, 1
 .word L181
 .word L201
 .word m_literal
 .word m_colon
 .word m_fetch
 .word L66
 .word m_literal
 .word 1
 .word L10
 .word m_minus
 .word m_store
 .word L195
 .word m_exit
 CIENTRY ";", L204, 1
 .word m_literal
 .word m_exit
 .word L67
 .word L184
 .word L7
 .word L202
 .word m_exit
 CIENTRY "recurse", L205, 7
 .word v_dp
 .word m_fetch
 .word L11
 .word L186
 .word L67
 .word m_exit
 CENTRY "char", L206, 4
 .word L3
 .word L144
 .word L29
 .word m_cfetch
 .word m_exit
 CENTRY "literal", L207, 7
 .word m_literal
 .word m_literal
 .word L67
 .word L67
 .word m_exit
 CENTRY "sliteral", L208, 8
 .word m_literal
 .word m_sliteral
 .word L67
 .word L66
 .word m_literal
 .word 34
 .word L141
 .word m_dup
 .word m_cfetch
 .word L29
 .word m_rpush
 .word m_xswap
 .word m_rfetch
 .word m_cmove
 .word m_rpop
 .word L69
 .word L71
 .word m_exit
 CENTRY "string", L209, 6
 .word L144
 .word m_dup
 .word m_cfetch
 .word L29
 .word m_rpush
 .word L66
 .word m_rfetch
 .word m_cmove
 .word m_rpop
 .word L69
 .word m_exit
 CIENTRY "[char]", L210, 6
 .word L3
 .word L144
 .word L29
 .word m_cfetch
 .word L207
 .word m_exit
 CIENTRY "[']", L211, 3
 .word L168
 .word L207
 .word m_exit
 CIENTRY "(", L212, 1
 .word m_literal
 .word 41
 .word L141
 .word m_drop
 .word m_exit
 CIENTRY "\\", L213, 1
 .word L126
 .word m_fetch
 .word m_cjump
 .word L214
 .word L120
 .word m_fetch
 .word m_literal
 .word 63
 .word m_plus
 .word m_literal
 .word 63
 .word L27
 .word m_binand
 .word L120
 .word m_store
 .word m_jump
 .word L215
L214:
 .word L121
 .word m_fetch
 .word L120
 .word m_store
L215:
 .word m_exit
 CENTRY "(?abort)", L216, 8
 .word L14
 .word m_cjump
 .word L217
 .word L83
 .word L81
 .word L82
 .word L127
 .word m_jump
 .word L218
L217:
 .word L15
L218:
 .word m_exit
 CIENTRY "abort\"", L219, 6
 .word L208
 .word m_literal
 .word L216
 .word L67
 .word m_exit
 CENTRY "\"", L220, 1
 .word m_literal
 .word 34
 .word L144
 .word L53
 .word m_rpush
 .word L66
 .word m_rfetch
 .word m_cmove
 .word L66
 .word m_rpop
 .word m_dup
 .word L69
 .word m_exit
 CENTRY "c\"", L221, 2
 .word m_literal
 .word 34
 .word L144
 .word m_dup
 .word m_cfetch
 .word L29
 .word m_rpush
 .word L66
 .word m_rfetch
 .word m_cmove
 .word L66
 .word m_rpop
 .word L69
 .word m_exit
 CIENTRY "s\"", L222, 2
 .word L208
 .word m_exit
 CIENTRY ".\"", L223, 2
 .word L208
 .word m_literal
 .word L81
 .word L67
 .word m_exit
 CIENTRY "if", L224, 2
 .word m_literal
 .word m_cjump
 .word L67
 .word L66
 .word m_literal
 .word 0
 .word L67
 .word m_exit
 CIENTRY "else", L225, 4
 .word m_literal
 .word m_jump
 .word L67
 .word L66
 .word m_rpush
 .word m_literal
 .word 0
 .word L67
 .word L66
 .word m_xswap
 .word m_store
 .word m_rpop
 .word m_exit
 CIENTRY "then", L226, 4
 .word L66
 .word m_xswap
 .word m_store
 .word m_exit
 CIENTRY "begin", L227, 5
 .word L66
 .word m_exit
 CIENTRY "again", L228, 5
 .word m_literal
 .word m_jump
 .word L67
 .word L67
 .word m_exit
 CIENTRY "until", L229, 5
 .word m_literal
 .word m_cjump
 .word L67
 .word L67
 .word m_exit
 CIENTRY "while", L230, 5
 .word m_literal
 .word m_cjump
 .word L67
 .word L66
 .word m_literal
 .word 0
 .word L67
 .word m_exit
 CIENTRY "repeat", L231, 6
 .word m_literal
 .word m_jump
 .word L67
 .word m_xswap
 .word L67
 .word L66
 .word m_xswap
 .word m_store
 .word m_exit
 CIENTRY "do", L232, 2
 .word m_literal
 .word m_doinit
 .word L67
 .word m_literal
 .word 0
 .word L66
 .word m_exit
 CIENTRY "loop", L233, 4
 .word m_literal
 .word m_doloop
 .word L67
 .word L67
 .word L19
 .word m_cjump
 .word L234
 .word L66
 .word m_xswap
 .word m_store
L234:
 .word m_exit
 CIENTRY "+loop", L235, 5
 .word m_literal
 .word m_doploop
 .word L67
 .word L67
 .word L19
 .word m_cjump
 .word L236
 .word L66
 .word m_xswap
 .word m_store
L236:
 .word m_exit
 CENTRY "w/o", L237, 3
 .word m_literal
 .word 1
 .word m_literal
 .word 512
 .word m_binor
 .word m_literal
 .word 64
 .word m_binor
 .word m_exit
 CENTRY "r/o", L238, 3
 .word m_literal
 .word 0
 .word m_exit
 CENTRY "r/w", L239, 3
 .word m_literal
 .word 2
 .word m_exit
 CENTRY "open-file", L240, 9
 .word m_rpush
 .word L70
 .word m_literal
 .word 1024
 .word m_plus
 .word m_xswap
 .word m_dup
 .word m_rpush
 .word m_cmove
 .word m_literal
 .word 0
 .word m_rpop
 .word L70
 .word m_plus
 .word m_literal
 .word 1024
 .word m_plus
 .word m_cstore
 .word L70
 .word m_literal
 .word 1024
 .word m_plus
 .word m_rpop
 .word m_literal
 .word 420
 .word m_fsopen
 .word m_dup
 .word m_literal
 .word -1
 .word m_greater
 .word m_exit
 CENTRY "close-file", L241, 10
 .word m_fsclose
 .word L34
 .word m_exit
 CENTRY "read-file", L242, 9
 .word m_fsread
 .word m_dup
 .word m_literal
 .word -1
 .word L37
 .word m_exit
 CENTRY "write-file", L243, 10
 .word m_fswrite
 .word m_literal
 .word -1
 .word L37
 .word m_exit
 CENTRY "reposition-file", L244, 15
 .word m_fsseek
 .word m_literal
 .word -1
 .word L37
 .word m_exit
 CENTRY "?fcheck", L245, 7
 .word L34
 .word m_cjump
 .word L246
 .word L83
 .word m_literal
 .word L247
 .word m_literal
 .word 9
 .word L81
 .word L82
 .word L127
L246:
 .word m_exit
 CENTRY "bye", L248, 3
 .word m_literal
 .word 0
 .word m_terminate
 .word m_exit
 CENTRY "include", L249, 7
 .word L3
 .word L144
 .word m_rpush
 .word L121
 .word m_fetch
 .word L120
 .word m_store
 .word L130
 .word m_rpop
 .word L53
 .word L238
 .word L240
 .word L245
 .word L74
 .word m_store
 .word m_exit
 CENTRY "crash", L250, 5
 .word m_literal
 .word L251
 .word m_literal
 .word 30
 .word L81
 .word L82
 .word L127
 .word m_exit
 CENTRY "quit", L252, 4
 .word m_reset
 .word m_clear
L253:
 .word L151
 .word L174
 .word L74
 .word m_fetch
 .word L34
 .word m_cjump
 .word L254
 .word m_literal
 .word L255
 .word m_literal
 .word 3
 .word L81
 .word L82
L254:
 .word m_jump
 .word L253
 .word m_exit
 CENTRY "(abort)", L256, 7
 .word L184
 .word L7
 .word v_tib
 .word L125
 .word m_store
 .word L126
 .word L7
 .word L74
 .word L7
 .word m_literal
 .word 1
 .word L75
 .word m_store
 .word L252
 .word m_exit
 CENTRY "boot", L257, 4
 .word m_reset
 .word m_clear
 .word m_stackptr
 .word L4
 .word m_store
 .word v_heaptop
 .word m_fetch
 .word m_literal
 .word 1
 .word L10
 .word m_minus
 .word m_fetch
 .word L5
 .word m_store
 .word m_literal
 .word L256
 .word L123
 .word m_store
 .word v_tib
 .word m_literal
 .word 1024
 .word m_plus
 .word L122
 .word m_store
 .word v_tib
 .word L125
 .word m_store
 .word m_literal
 .word 0
 .word L74
 .word m_store
 .word m_literal
 .word 1
 .word L75
 .word m_store
 .word L184
 .word L7
 .word L104
 .word L252
 .word m_exit
L137:
 .ascii "unable to restore input"
L170:
 .ascii " ?"
L173:
 .ascii " stack underflow"
L180:
 .ascii " ?"
L193:
 .ascii " ?"
L247:
 .ascii "I/O error"
L251:
 .ascii "uninitialized execution vector"
L255:
 .ascii " ok"
