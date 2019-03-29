//
//  Mapping.swift
//  lyrebird
//
//  Created by Robin Diddams on 3/27/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

let padding: String = "\u{2615}"
let padding40: String = "\u{269C}"
let padding41: String = "\u{1F3CD}"
let padding42: String = "\u{1F4D1}"
let padding43: String = "\u{1F64B}"

let emojis: [String] = {
    var emojis = [String](repeating: "", count: 1024)
    emojis[0] = "🀄"
    emojis[1] = "🃏"
    emojis[2] = "🅰"
    emojis[3] = "🅱"
    emojis[4] = "🅾"
    emojis[5] = "🅿"
    emojis[6] = "🆎"
    emojis[7] = "🆑"
    emojis[8] = "🆒"
    emojis[9] = "🆓"
    emojis[10] = "🆔"
    emojis[11] = "🆕"
    emojis[12] = "🆖"
    emojis[13] = "🆗"
    emojis[14] = "🆘"
    emojis[15] = "🆙"
    emojis[16] = "🆚"
    emojis[17] = "🇦"
    emojis[18] = "🇧"
    emojis[19] = "🇨"
    emojis[20] = "🇩"
    emojis[21] = "🇪"
    emojis[22] = "🇫"
    emojis[23] = "🇬"
    emojis[24] = "🇭"
    emojis[25] = "🇮"
    emojis[26] = "🇯"
    emojis[27] = "🇰"
    emojis[28] = "🇱"
    emojis[29] = "🇲"
    emojis[30] = "🇳"
    emojis[31] = "🇴"
    emojis[32] = "🇵"
    emojis[33] = "🇶"
    emojis[34] = "🇷"
    emojis[35] = "🇸"
    emojis[36] = "🇹"
    emojis[37] = "🇺"
    emojis[38] = "🇻"
    emojis[39] = "🇼"
    emojis[40] = "🇽"
    emojis[41] = "🇾"
    emojis[42] = "🇿"
    emojis[43] = "🈁"
    emojis[44] = "🈂"
    emojis[45] = "🈚"
    emojis[46] = "🈯"
    emojis[47] = "🈲"
    emojis[48] = "🈳"
    emojis[49] = "🈴"
    emojis[50] = "🈵"
    emojis[51] = "🈶"
    emojis[52] = "🈷"
    emojis[53] = "🈸"
    emojis[54] = "🈹"
    emojis[55] = "🈺"
    emojis[56] = "🉐"
    emojis[57] = "🉑"
    emojis[58] = "🌀"
    emojis[59] = "🌁"
    emojis[60] = "🌂"
    emojis[61] = "🌃"
    emojis[62] = "🌄"
    emojis[63] = "🌅"
    emojis[64] = "🌆"
    emojis[65] = "🌇"
    emojis[66] = "🌈"
    emojis[67] = "🌉"
    emojis[68] = "🌊"
    emojis[69] = "🌋"
    emojis[70] = "🌌"
    emojis[71] = "🌍"
    emojis[72] = "🌎"
    emojis[73] = "🌏"
    emojis[74] = "🌐"
    emojis[75] = "🌑"
    emojis[76] = "🌒"
    emojis[77] = "🌓"
    emojis[78] = "🌔"
    emojis[79] = "🌕"
    emojis[80] = "🌖"
    emojis[81] = "🌗"
    emojis[82] = "🌘"
    emojis[83] = "🌙"
    emojis[84] = "🌚"
    emojis[85] = "🌛"
    emojis[86] = "🌜"
    emojis[87] = "🌝"
    emojis[88] = "🌞"
    emojis[89] = "🌟"
    emojis[90] = "🌠"
    emojis[91] = "🌡"
    emojis[92] = "🌤"
    emojis[93] = "🌥"
    emojis[94] = "🌦"
    emojis[95] = "🌧"
    emojis[96] = "🌨"
    emojis[97] = "🌩"
    emojis[98] = "🌪"
    emojis[99] = "🌫"
    emojis[100] = "🌬"
    emojis[101] = "🌭"
    emojis[102] = "🌮"
    emojis[103] = "🌯"
    emojis[104] = "🌰"
    emojis[105] = "🌱"
    emojis[106] = "🌲"
    emojis[107] = "🌳"
    emojis[108] = "🌴"
    emojis[109] = "🌵"
    emojis[110] = "🌶"
    emojis[111] = "🌷"
    emojis[112] = "🌸"
    emojis[113] = "🌹"
    emojis[114] = "🌺"
    emojis[115] = "🌻"
    emojis[116] = "🌼"
    emojis[117] = "🌽"
    emojis[118] = "🌾"
    emojis[119] = "🌿"
    emojis[120] = "🍀"
    emojis[121] = "🍁"
    emojis[122] = "🍂"
    emojis[123] = "🍃"
    emojis[124] = "🍄"
    emojis[125] = "🍅"
    emojis[126] = "🍆"
    emojis[127] = "🍇"
    emojis[128] = "🍈"
    emojis[129] = "🍉"
    emojis[130] = "🍊"
    emojis[131] = "🍋"
    emojis[132] = "🍌"
    emojis[133] = "🍍"
    emojis[134] = "🍎"
    emojis[135] = "🍏"
    emojis[136] = "🍐"
    emojis[137] = "🍑"
    emojis[138] = "🍒"
    emojis[139] = "🍓"
    emojis[140] = "🍔"
    emojis[141] = "🍕"
    emojis[142] = "🍖"
    emojis[143] = "🍗"
    emojis[144] = "🍘"
    emojis[145] = "🍙"
    emojis[146] = "🍚"
    emojis[147] = "🍛"
    emojis[148] = "🍜"
    emojis[149] = "🍝"
    emojis[150] = "🍞"
    emojis[151] = "🍟"
    emojis[152] = "🍠"
    emojis[153] = "🍡"
    emojis[154] = "🍢"
    emojis[155] = "🍣"
    emojis[156] = "🍤"
    emojis[157] = "🍥"
    emojis[158] = "🍦"
    emojis[159] = "🍧"
    emojis[160] = "🍨"
    emojis[161] = "🍩"
    emojis[162] = "🍪"
    emojis[163] = "🍫"
    emojis[164] = "🍬"
    emojis[165] = "🍭"
    emojis[166] = "🍮"
    emojis[167] = "🍯"
    emojis[168] = "🍰"
    emojis[169] = "🍱"
    emojis[170] = "🍲"
    emojis[171] = "🍳"
    emojis[172] = "🍴"
    emojis[173] = "🍵"
    emojis[174] = "🍶"
    emojis[175] = "🍷"
    emojis[176] = "🍸"
    emojis[177] = "🍹"
    emojis[178] = "🍺"
    emojis[179] = "🍻"
    emojis[180] = "🍼"
    emojis[181] = "🍽"
    emojis[182] = "🍾"
    emojis[183] = "🍿"
    emojis[184] = "🎀"
    emojis[185] = "🎁"
    emojis[186] = "🎂"
    emojis[187] = "🎃"
    emojis[188] = "🎄"
    emojis[189] = "🎅"
    emojis[190] = "🎆"
    emojis[191] = "🎇"
    emojis[192] = "🎈"
    emojis[193] = "🎉"
    emojis[194] = "🎊"
    emojis[195] = "🎋"
    emojis[196] = "🎌"
    emojis[197] = "🎍"
    emojis[198] = "🎎"
    emojis[199] = "🎏"
    emojis[200] = "🎐"
    emojis[201] = "🎑"
    emojis[202] = "🎒"
    emojis[203] = "🎓"
    emojis[204] = "🎖"
    emojis[205] = "🎗"
    emojis[206] = "🎙"
    emojis[207] = "🎚"
    emojis[208] = "🎛"
    emojis[209] = "🎞"
    emojis[210] = "🎟"
    emojis[211] = "🎠"
    emojis[212] = "🎡"
    emojis[213] = "🎢"
    emojis[214] = "🎣"
    emojis[215] = "🎤"
    emojis[216] = "🎥"
    emojis[217] = "🎦"
    emojis[218] = "🎧"
    emojis[219] = "🎨"
    emojis[220] = "🎩"
    emojis[221] = "🎪"
    emojis[222] = "🎫"
    emojis[223] = "🎬"
    emojis[224] = "🎭"
    emojis[225] = "🎮"
    emojis[226] = "🎯"
    emojis[227] = "🎰"
    emojis[228] = "🎱"
    emojis[229] = "🎲"
    emojis[230] = "🎳"
    emojis[231] = "🎴"
    emojis[232] = "🎵"
    emojis[233] = "🎶"
    emojis[234] = "🎷"
    emojis[235] = "🎸"
    emojis[236] = "🎹"
    emojis[237] = "🎺"
    emojis[238] = "🎻"
    emojis[239] = "🎼"
    emojis[240] = "🎽"
    emojis[241] = "🎾"
    emojis[242] = "🎿"
    emojis[243] = "🏀"
    emojis[244] = "🏁"
    emojis[245] = "🏂"
    emojis[246] = "🏃"
    emojis[247] = "🏄"
    emojis[248] = "🏅"
    emojis[249] = "🏆"
    emojis[250] = "🏇"
    emojis[251] = "🏈"
    emojis[252] = "🏉"
    emojis[253] = "🏊"
    emojis[254] = "🏋"
    emojis[255] = "🏌"
    emojis[256] = "🏎"
    emojis[257] = "🏏"
    emojis[258] = "🏐"
    emojis[259] = "🏑"
    emojis[260] = "🏒"
    emojis[261] = "🏓"
    emojis[262] = "🏔"
    emojis[263] = "🏕"
    emojis[264] = "🏖"
    emojis[265] = "🏗"
    emojis[266] = "🏘"
    emojis[267] = "🏙"
    emojis[268] = "🏚"
    emojis[269] = "🏛"
    emojis[270] = "🏜"
    emojis[271] = "🏝"
    emojis[272] = "🏞"
    emojis[273] = "🏟"
    emojis[274] = "🏠"
    emojis[275] = "🏡"
    emojis[276] = "🏢"
    emojis[277] = "🏣"
    emojis[278] = "🏤"
    emojis[279] = "🏥"
    emojis[280] = "🏦"
    emojis[281] = "🏧"
    emojis[282] = "🏨"
    emojis[283] = "🏩"
    emojis[284] = "🏪"
    emojis[285] = "🏫"
    emojis[286] = "🏬"
    emojis[287] = "🏭"
    emojis[288] = "🏮"
    emojis[289] = "🏯"
    emojis[290] = "🏰"
    emojis[291] = "🏳"
    emojis[292] = "🏴"
    emojis[293] = "🏵"
    emojis[294] = "🏷"
    emojis[295] = "🏸"
    emojis[296] = "🏹"
    emojis[297] = "🏺"
    emojis[298] = "🏻"
    emojis[299] = "🏼"
    emojis[300] = "🏽"
    emojis[301] = "🏾"
    emojis[302] = "🏿"
    emojis[303] = "🐀"
    emojis[304] = "🐁"
    emojis[305] = "🐂"
    emojis[306] = "🐃"
    emojis[307] = "🐄"
    emojis[308] = "🐅"
    emojis[309] = "🐆"
    emojis[310] = "🐇"
    emojis[311] = "🐈"
    emojis[312] = "🐉"
    emojis[313] = "🐊"
    emojis[314] = "🐋"
    emojis[315] = "🐌"
    emojis[316] = "🐍"
    emojis[317] = "🐎"
    emojis[318] = "🐏"
    emojis[319] = "🐐"
    emojis[320] = "🐑"
    emojis[321] = "🐒"
    emojis[322] = "🐓"
    emojis[323] = "🐔"
    emojis[324] = "🐕"
    emojis[325] = "🐖"
    emojis[326] = "🐗"
    emojis[327] = "🐘"
    emojis[328] = "🐙"
    emojis[329] = "🐚"
    emojis[330] = "🐛"
    emojis[331] = "🐜"
    emojis[332] = "🐝"
    emojis[333] = "🐞"
    emojis[334] = "🐟"
    emojis[335] = "🐠"
    emojis[336] = "🐡"
    emojis[337] = "🐢"
    emojis[338] = "🐣"
    emojis[339] = "🐤"
    emojis[340] = "🐥"
    emojis[341] = "🐦"
    emojis[342] = "🐧"
    emojis[343] = "🐨"
    emojis[344] = "🐩"
    emojis[345] = "🐪"
    emojis[346] = "🐫"
    emojis[347] = "🐬"
    emojis[348] = "🐭"
    emojis[349] = "🐮"
    emojis[350] = "🐯"
    emojis[351] = "🐰"
    emojis[352] = "🐱"
    emojis[353] = "🐲"
    emojis[354] = "🐳"
    emojis[355] = "🐴"
    emojis[356] = "🐵"
    emojis[357] = "🐶"
    emojis[358] = "🐷"
    emojis[359] = "🐸"
    emojis[360] = "🐹"
    emojis[361] = "🐺"
    emojis[362] = "🐻"
    emojis[363] = "🐼"
    emojis[364] = "🐽"
    emojis[365] = "🐾"
    emojis[366] = "🐿"
    emojis[367] = "👀"
    emojis[368] = "👁"
    emojis[369] = "👂"
    emojis[370] = "👃"
    emojis[371] = "👄"
    emojis[372] = "👅"
    emojis[373] = "👆"
    emojis[374] = "👇"
    emojis[375] = "👈"
    emojis[376] = "👉"
    emojis[377] = "👊"
    emojis[378] = "👋"
    emojis[379] = "👌"
    emojis[380] = "👍"
    emojis[381] = "👎"
    emojis[382] = "👏"
    emojis[383] = "👐"
    emojis[384] = "👑"
    emojis[385] = "👒"
    emojis[386] = "👓"
    emojis[387] = "👔"
    emojis[388] = "👕"
    emojis[389] = "👖"
    emojis[390] = "👗"
    emojis[391] = "👘"
    emojis[392] = "👙"
    emojis[393] = "👚"
    emojis[394] = "👛"
    emojis[395] = "👜"
    emojis[396] = "👝"
    emojis[397] = "👞"
    emojis[398] = "👟"
    emojis[399] = "👠"
    emojis[400] = "👡"
    emojis[401] = "👢"
    emojis[402] = "👣"
    emojis[403] = "👤"
    emojis[404] = "👥"
    emojis[405] = "👦"
    emojis[406] = "👧"
    emojis[407] = "👨"
    emojis[408] = "👩"
    emojis[409] = "👪"
    emojis[410] = "👫"
    emojis[411] = "👬"
    emojis[412] = "👭"
    emojis[413] = "👮"
    emojis[414] = "👯"
    emojis[415] = "👰"
    emojis[416] = "👱"
    emojis[417] = "👲"
    emojis[418] = "👳"
    emojis[419] = "👴"
    emojis[420] = "👵"
    emojis[421] = "👶"
    emojis[422] = "👷"
    emojis[423] = "👸"
    emojis[424] = "👹"
    emojis[425] = "👺"
    emojis[426] = "👻"
    emojis[427] = "👼"
    emojis[428] = "👽"
    emojis[429] = "👾"
    emojis[430] = "👿"
    emojis[431] = "💀"
    emojis[432] = "💁"
    emojis[433] = "💂"
    emojis[434] = "💃"
    emojis[435] = "💄"
    emojis[436] = "💅"
    emojis[437] = "💆"
    emojis[438] = "💇"
    emojis[439] = "💈"
    emojis[440] = "💉"
    emojis[441] = "💊"
    emojis[442] = "💋"
    emojis[443] = "💌"
    emojis[444] = "💍"
    emojis[445] = "💎"
    emojis[446] = "💏"
    emojis[447] = "💐"
    emojis[448] = "💑"
    emojis[449] = "💒"
    emojis[450] = "💓"
    emojis[451] = "💔"
    emojis[452] = "💕"
    emojis[453] = "💖"
    emojis[454] = "💗"
    emojis[455] = "💘"
    emojis[456] = "💙"
    emojis[457] = "💚"
    emojis[458] = "💛"
    emojis[459] = "💜"
    emojis[460] = "💝"
    emojis[461] = "💞"
    emojis[462] = "💟"
    emojis[463] = "💠"
    emojis[464] = "💡"
    emojis[465] = "💢"
    emojis[466] = "💣"
    emojis[467] = "💤"
    emojis[468] = "💥"
    emojis[469] = "💦"
    emojis[470] = "💧"
    emojis[471] = "💨"
    emojis[472] = "💩"
    emojis[473] = "💪"
    emojis[474] = "💫"
    emojis[475] = "💬"
    emojis[476] = "💭"
    emojis[477] = "💮"
    emojis[478] = "💯"
    emojis[479] = "💰"
    emojis[480] = "💱"
    emojis[481] = "💲"
    emojis[482] = "💳"
    emojis[483] = "💴"
    emojis[484] = "💵"
    emojis[485] = "💶"
    emojis[486] = "💷"
    emojis[487] = "💸"
    emojis[488] = "💹"
    emojis[489] = "💺"
    emojis[490] = "💻"
    emojis[491] = "💼"
    emojis[492] = "💽"
    emojis[493] = "💾"
    emojis[494] = "💿"
    emojis[495] = "📀"
    emojis[496] = "📁"
    emojis[497] = "📂"
    emojis[498] = "📃"
    emojis[499] = "📄"
    emojis[500] = "📅"
    emojis[501] = "📆"
    emojis[502] = "📇"
    emojis[503] = "📈"
    emojis[504] = "📉"
    emojis[505] = "📊"
    emojis[506] = "📋"
    emojis[507] = "📌"
    emojis[508] = "📍"
    emojis[509] = "📎"
    emojis[510] = "📏"
    emojis[511] = "📐"
    emojis[512] = "📒"
    emojis[513] = "📓"
    emojis[514] = "📔"
    emojis[515] = "📕"
    emojis[516] = "📖"
    emojis[517] = "📗"
    emojis[518] = "📘"
    emojis[519] = "📙"
    emojis[520] = "📚"
    emojis[521] = "📛"
    emojis[522] = "📜"
    emojis[523] = "📝"
    emojis[524] = "📞"
    emojis[525] = "📟"
    emojis[526] = "📠"
    emojis[527] = "📡"
    emojis[528] = "📢"
    emojis[529] = "📣"
    emojis[530] = "📤"
    emojis[531] = "📥"
    emojis[532] = "📦"
    emojis[533] = "📧"
    emojis[534] = "📨"
    emojis[535] = "📩"
    emojis[536] = "📪"
    emojis[537] = "📫"
    emojis[538] = "📬"
    emojis[539] = "📭"
    emojis[540] = "📮"
    emojis[541] = "📯"
    emojis[542] = "📰"
    emojis[543] = "📱"
    emojis[544] = "📲"
    emojis[545] = "📳"
    emojis[546] = "📴"
    emojis[547] = "📵"
    emojis[548] = "📶"
    emojis[549] = "📷"
    emojis[550] = "📸"
    emojis[551] = "📹"
    emojis[552] = "📺"
    emojis[553] = "📻"
    emojis[554] = "📼"
    emojis[555] = "📽"
    emojis[556] = "📿"
    emojis[557] = "🔀"
    emojis[558] = "🔁"
    emojis[559] = "🔂"
    emojis[560] = "🔃"
    emojis[561] = "🔄"
    emojis[562] = "🔅"
    emojis[563] = "🔆"
    emojis[564] = "🔇"
    emojis[565] = "🔈"
    emojis[566] = "🔉"
    emojis[567] = "🔊"
    emojis[568] = "🔋"
    emojis[569] = "🔌"
    emojis[570] = "🔍"
    emojis[571] = "🔎"
    emojis[572] = "🔏"
    emojis[573] = "🔐"
    emojis[574] = "🔑"
    emojis[575] = "🔒"
    emojis[576] = "🔓"
    emojis[577] = "🔔"
    emojis[578] = "🔕"
    emojis[579] = "🔖"
    emojis[580] = "🔗"
    emojis[581] = "🔘"
    emojis[582] = "🔙"
    emojis[583] = "🔚"
    emojis[584] = "🔛"
    emojis[585] = "🔜"
    emojis[586] = "🔝"
    emojis[587] = "🔞"
    emojis[588] = "🔟"
    emojis[589] = "🔠"
    emojis[590] = "🔡"
    emojis[591] = "🔢"
    emojis[592] = "🔣"
    emojis[593] = "🔤"
    emojis[594] = "🔥"
    emojis[595] = "🔦"
    emojis[596] = "🔧"
    emojis[597] = "🔨"
    emojis[598] = "🔩"
    emojis[599] = "🔪"
    emojis[600] = "🔫"
    emojis[601] = "🔬"
    emojis[602] = "🔭"
    emojis[603] = "🔮"
    emojis[604] = "🔯"
    emojis[605] = "🔰"
    emojis[606] = "🔱"
    emojis[607] = "🔲"
    emojis[608] = "🔳"
    emojis[609] = "🔴"
    emojis[610] = "🔵"
    emojis[611] = "🔶"
    emojis[612] = "🔷"
    emojis[613] = "🔸"
    emojis[614] = "🔹"
    emojis[615] = "🔺"
    emojis[616] = "🔻"
    emojis[617] = "🔼"
    emojis[618] = "🔽"
    emojis[619] = "🕉"
    emojis[620] = "🕊"
    emojis[621] = "🕋"
    emojis[622] = "🕌"
    emojis[623] = "🕍"
    emojis[624] = "🕎"
    emojis[625] = "🕐"
    emojis[626] = "🕑"
    emojis[627] = "🕒"
    emojis[628] = "🕓"
    emojis[629] = "🕔"
    emojis[630] = "🕕"
    emojis[631] = "🕖"
    emojis[632] = "🕗"
    emojis[633] = "🕘"
    emojis[634] = "🕙"
    emojis[635] = "🕚"
    emojis[636] = "🕛"
    emojis[637] = "🕜"
    emojis[638] = "🕝"
    emojis[639] = "🕞"
    emojis[640] = "🕟"
    emojis[641] = "🕠"
    emojis[642] = "🕡"
    emojis[643] = "🕢"
    emojis[644] = "🕣"
    emojis[645] = "🕤"
    emojis[646] = "🕥"
    emojis[647] = "🕦"
    emojis[648] = "🕧"
    emojis[649] = "🕯"
    emojis[650] = "🕰"
    emojis[651] = "🕳"
    emojis[652] = "🕴"
    emojis[653] = "🕵"
    emojis[654] = "🕶"
    emojis[655] = "🕷"
    emojis[656] = "🕸"
    emojis[657] = "🕹"
    emojis[658] = "🕺"
    emojis[659] = "🖇"
    emojis[660] = "🖊"
    emojis[661] = "🖋"
    emojis[662] = "🖌"
    emojis[663] = "🖍"
    emojis[664] = "🖐"
    emojis[665] = "🖕"
    emojis[666] = "🖖"
    emojis[667] = "🖤"
    emojis[668] = "🖥"
    emojis[669] = "🖨"
    emojis[670] = "🖱"
    emojis[671] = "🖲"
    emojis[672] = "🖼"
    emojis[673] = "🗂"
    emojis[674] = "🗃"
    emojis[675] = "🗄"
    emojis[676] = "🗑"
    emojis[677] = "🗒"
    emojis[678] = "🗓"
    emojis[679] = "🗜"
    emojis[680] = "🗝"
    emojis[681] = "🗞"
    emojis[682] = "🗡"
    emojis[683] = "🗣"
    emojis[684] = "🗨"
    emojis[685] = "🗯"
    emojis[686] = "🗳"
    emojis[687] = "🗺"
    emojis[688] = "🗻"
    emojis[689] = "🗼"
    emojis[690] = "🗽"
    emojis[691] = "🗾"
    emojis[692] = "🗿"
    emojis[693] = "😀"
    emojis[694] = "😁"
    emojis[695] = "😂"
    emojis[696] = "😃"
    emojis[697] = "😄"
    emojis[698] = "😅"
    emojis[699] = "😆"
    emojis[700] = "😇"
    emojis[701] = "😈"
    emojis[702] = "😉"
    emojis[703] = "😊"
    emojis[704] = "😋"
    emojis[705] = "😌"
    emojis[706] = "😍"
    emojis[707] = "😎"
    emojis[708] = "😏"
    emojis[709] = "😐"
    emojis[710] = "😑"
    emojis[711] = "😒"
    emojis[712] = "😓"
    emojis[713] = "😔"
    emojis[714] = "😕"
    emojis[715] = "😖"
    emojis[716] = "😗"
    emojis[717] = "😘"
    emojis[718] = "😙"
    emojis[719] = "😚"
    emojis[720] = "😛"
    emojis[721] = "😜"
    emojis[722] = "😝"
    emojis[723] = "😞"
    emojis[724] = "😟"
    emojis[725] = "😠"
    emojis[726] = "😡"
    emojis[727] = "😢"
    emojis[728] = "😣"
    emojis[729] = "😤"
    emojis[730] = "😥"
    emojis[731] = "😦"
    emojis[732] = "😧"
    emojis[733] = "😨"
    emojis[734] = "😩"
    emojis[735] = "😪"
    emojis[736] = "😫"
    emojis[737] = "😬"
    emojis[738] = "😭"
    emojis[739] = "😮"
    emojis[740] = "😯"
    emojis[741] = "😰"
    emojis[742] = "😱"
    emojis[743] = "😲"
    emojis[744] = "😳"
    emojis[745] = "😴"
    emojis[746] = "😵"
    emojis[747] = "😶"
    emojis[748] = "😷"
    emojis[749] = "😸"
    emojis[750] = "😹"
    emojis[751] = "😺"
    emojis[752] = "😻"
    emojis[753] = "😼"
    emojis[754] = "😽"
    emojis[755] = "😾"
    emojis[756] = "😿"
    emojis[757] = "🙀"
    emojis[758] = "🙁"
    emojis[759] = "🙂"
    emojis[760] = "🙃"
    emojis[761] = "🙄"
    emojis[762] = "🙅"
    emojis[763] = "🙆"
    emojis[764] = "🙇"
    emojis[765] = "🙈"
    emojis[766] = "🙉"
    emojis[767] = "🙊"
    emojis[768] = "🙌"
    emojis[769] = "🙍"
    emojis[770] = "🙎"
    emojis[771] = "🙏"
    emojis[772] = "🚀"
    emojis[773] = "🚁"
    emojis[774] = "🚂"
    emojis[775] = "🚃"
    emojis[776] = "🚄"
    emojis[777] = "🚅"
    emojis[778] = "🚆"
    emojis[779] = "🚇"
    emojis[780] = "🚈"
    emojis[781] = "🚉"
    emojis[782] = "🚊"
    emojis[783] = "🚋"
    emojis[784] = "🚌"
    emojis[785] = "🚍"
    emojis[786] = "🚎"
    emojis[787] = "🚏"
    emojis[788] = "🚐"
    emojis[789] = "🚑"
    emojis[790] = "🚒"
    emojis[791] = "🚓"
    emojis[792] = "🚔"
    emojis[793] = "🚕"
    emojis[794] = "🚖"
    emojis[795] = "🚗"
    emojis[796] = "🚘"
    emojis[797] = "🚙"
    emojis[798] = "🚚"
    emojis[799] = "🚛"
    emojis[800] = "🚜"
    emojis[801] = "🚝"
    emojis[802] = "🚞"
    emojis[803] = "🚟"
    emojis[804] = "🚠"
    emojis[805] = "🚡"
    emojis[806] = "🚢"
    emojis[807] = "🚣"
    emojis[808] = "🚤"
    emojis[809] = "🚥"
    emojis[810] = "🚦"
    emojis[811] = "🚧"
    emojis[812] = "🚨"
    emojis[813] = "🚩"
    emojis[814] = "🚪"
    emojis[815] = "🚫"
    emojis[816] = "🚬"
    emojis[817] = "🚭"
    emojis[818] = "🚮"
    emojis[819] = "🚯"
    emojis[820] = "🚰"
    emojis[821] = "🚱"
    emojis[822] = "🚲"
    emojis[823] = "🚳"
    emojis[824] = "🚴"
    emojis[825] = "🚵"
    emojis[826] = "🚶"
    emojis[827] = "🚷"
    emojis[828] = "🚸"
    emojis[829] = "🚹"
    emojis[830] = "🚺"
    emojis[831] = "🚻"
    emojis[832] = "🚼"
    emojis[833] = "🚽"
    emojis[834] = "🚾"
    emojis[835] = "🚿"
    emojis[836] = "🛀"
    emojis[837] = "🛁"
    emojis[838] = "🛂"
    emojis[839] = "🛃"
    emojis[840] = "🛄"
    emojis[841] = "🛅"
    emojis[842] = "🛋"
    emojis[843] = "🛌"
    emojis[844] = "🛍"
    emojis[845] = "🛎"
    emojis[846] = "🛏"
    emojis[847] = "🛐"
    emojis[848] = "🛑"
    emojis[849] = "🛒"
    emojis[850] = "🛠"
    emojis[851] = "🛡"
    emojis[852] = "🛢"
    emojis[853] = "🛣"
    emojis[854] = "🛤"
    emojis[855] = "🛥"
    emojis[856] = "🛩"
    emojis[857] = "🛫"
    emojis[858] = "🛬"
    emojis[859] = "🛰"
    emojis[860] = "🛳"
    emojis[861] = "🛴"
    emojis[862] = "🛵"
    emojis[863] = "🛶"
    emojis[864] = "🛷"
    emojis[865] = "🛸"
    emojis[866] = "🛹"
    emojis[867] = "🤐"
    emojis[868] = "🤑"
    emojis[869] = "🤒"
    emojis[870] = "🤓"
    emojis[871] = "🤔"
    emojis[872] = "🤕"
    emojis[873] = "🤖"
    emojis[874] = "🤗"
    emojis[875] = "🤘"
    emojis[876] = "🤙"
    emojis[877] = "🤚"
    emojis[878] = "🤛"
    emojis[879] = "🤜"
    emojis[880] = "🤝"
    emojis[881] = "🤞"
    emojis[882] = "🤟"
    emojis[883] = "🤠"
    emojis[884] = "🤡"
    emojis[885] = "🤢"
    emojis[886] = "🤣"
    emojis[887] = "🤤"
    emojis[888] = "🤥"
    emojis[889] = "🤦"
    emojis[890] = "🤧"
    emojis[891] = "🤨"
    emojis[892] = "🤩"
    emojis[893] = "🤪"
    emojis[894] = "🤫"
    emojis[895] = "🤬"
    emojis[896] = "🤭"
    emojis[897] = "🤮"
    emojis[898] = "🤯"
    emojis[899] = "🤰"
    emojis[900] = "🤱"
    emojis[901] = "🤲"
    emojis[902] = "🤳"
    emojis[903] = "🤴"
    emojis[904] = "🤵"
    emojis[905] = "🤶"
    emojis[906] = "🤷"
    emojis[907] = "🤸"
    emojis[908] = "🤹"
    emojis[909] = "🤺"
    emojis[910] = "🤼"
    emojis[911] = "🤽"
    emojis[912] = "🤾"
    emojis[913] = "🥀"
    emojis[914] = "🥁"
    emojis[915] = "🥂"
    emojis[916] = "🥃"
    emojis[917] = "🥄"
    emojis[918] = "🥅"
    emojis[919] = "🥇"
    emojis[920] = "🥈"
    emojis[921] = "🥉"
    emojis[922] = "🥊"
    emojis[923] = "🥋"
    emojis[924] = "🥌"
    emojis[925] = "🥍"
    emojis[926] = "🥎"
    emojis[927] = "🥏"
    emojis[928] = "🥐"
    emojis[929] = "🥑"
    emojis[930] = "🥒"
    emojis[931] = "🥓"
    emojis[932] = "🥔"
    emojis[933] = "🥕"
    emojis[934] = "🥖"
    emojis[935] = "🥗"
    emojis[936] = "🥘"
    emojis[937] = "🥙"
    emojis[938] = "🥚"
    emojis[939] = "🥛"
    emojis[940] = "🥜"
    emojis[941] = "🥝"
    emojis[942] = "🥞"
    emojis[943] = "🥟"
    emojis[944] = "🥠"
    emojis[945] = "🥡"
    emojis[946] = "🥢"
    emojis[947] = "🥣"
    emojis[948] = "🥤"
    emojis[949] = "🥥"
    emojis[950] = "🥦"
    emojis[951] = "🥧"
    emojis[952] = "🥨"
    emojis[953] = "🥩"
    emojis[954] = "🥪"
    emojis[955] = "🥫"
    emojis[956] = "🥬"
    emojis[957] = "🥭"
    emojis[958] = "🥮"
    emojis[959] = "🥯"
    emojis[960] = "🥰"
    emojis[961] = "🥳"
    emojis[962] = "🥴"
    emojis[963] = "🥵"
    emojis[964] = "🥶"
    emojis[965] = "🥺"
    emojis[966] = "🥼"
    emojis[967] = "🥽"
    emojis[968] = "🥾"
    emojis[969] = "🥿"
    emojis[970] = "🦀"
    emojis[971] = "🦁"
    emojis[972] = "🦂"
    emojis[973] = "🦃"
    emojis[974] = "🦄"
    emojis[975] = "🦅"
    emojis[976] = "🦆"
    emojis[977] = "🦇"
    emojis[978] = "🦈"
    emojis[979] = "🦉"
    emojis[980] = "🦊"
    emojis[981] = "🦋"
    emojis[982] = "🦌"
    emojis[983] = "🦍"
    emojis[984] = "🦎"
    emojis[985] = "🦏"
    emojis[986] = "🦐"
    emojis[987] = "🦑"
    emojis[988] = "🦒"
    emojis[989] = "🦓"
    emojis[990] = "🦔"
    emojis[991] = "🦕"
    emojis[992] = "🦖"
    emojis[993] = "🦗"
    emojis[994] = "🦘"
    emojis[995] = "🦙"
    emojis[996] = "🦚"
    emojis[997] = "🦛"
    emojis[998] = "🦜"
    emojis[999] = "🦝"
    emojis[1000] = "🦞"
    emojis[1001] = "🦟"
    emojis[1002] = "🦠"
    emojis[1003] = "🦡"
    emojis[1004] = "🦢"
    emojis[1005] = "🦰"
    emojis[1006] = "🦱"
    emojis[1007] = "🦲"
    emojis[1008] = "🦳"
    emojis[1009] = "🦴"
    emojis[1010] = "🦵"
    emojis[1011] = "🦶"
    emojis[1012] = "🦷"
    emojis[1013] = "🦸"
    emojis[1014] = "🦹"
    emojis[1015] = "🧀"
    emojis[1016] = "🧁"
    emojis[1017] = "🧂"
    emojis[1018] = "🧐"
    emojis[1019] = "🧑"
    emojis[1020] = "🧒"
    emojis[1021] = "🧓"
    emojis[1022] = "🧔"
    emojis[1023] = "🧕"
    return emojis
}()