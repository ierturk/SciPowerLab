// ErturkMe - Copyright 2011 - 2022
// http://erturk.me
// ierturk@ieee.org
// See license.txt

function LoadPalette()

	if exists("scicos_diagram", 'a') == 0 then loadXcosLibs(); end
	pal = xcosPal('ErturkMe - Palette for Electrical Machines');

	Pal_Dir = get_absolute_file_path('load_palette.sce');

	Pal_Style = [..
					'xcpl_BLDC',..
					'blockWithLabel;verticalLabelPosition=middle;spacing=15;'..
						+ 'displayedLabel='..
						+ '<table>'..
						+	'<tr>'..
						+		'<td>Tload</td>'..
						+		'<th rowspan=""3"">BLDC</th>'..
						+		'<td>theta</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td></td>'..
						+		'<td>I_abc</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>V_abc</td>'..
						+		'<td>wr</td>'..
						+	'</tr>'..
						+ '</table>;';

					'xcpl_IMPU',..
					'blockWithLabel;verticalLabelPosition=middle;spacing=15;'..
						+ 'displayedLabel='..
						+ '<table>'..
						+	'<tr>'..
						+		'<td>V_dq</td>'..
						+		'<th rowspan=""3"">IMPU</th>'..
						+		'<td>I_dq</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td></td>'..
						+		'<td>Phi_dq</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>Tload</td>'..
						+		'<td>w</td>'..
						+	'</tr>'..
						+ '</table>;';
						
					'xcpl_PMSM',..
					'blockWithLabel;verticalLabelPosition=middle;spacing=15;'..
						+ 'displayedLabel='..
						+ '<table>'..
						+	'<tr>'..
						+		'<td>V_dq</td>'..
						+		'<th rowspan=""3"">PMSM</th>'..
						+		'<td>I_dq</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td></td>'..
						+		'<td>wr</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>Tload</td>'..
						+		'<td>theta</td>'..
						+	'</tr>'..
						+ '</table>;';
				]

	list_blocks_from_scicos=[];

	for block = list_blocks_from_scicos'
		//pal.blockNames($+1) = 'pl_' + block;
		//pal.blocks($+1) = SCI + '/modules/scicos_blocks/blocks/' + block + '.h5';

		block = strsubst(block, '_m', '');
		block = strsubst(block, '_f', '');

		if isfile(SCI + '/modules/xcos/images/palettes/'..
						+ block + '_m.png') then
			pal.blockNames($+1) = block+'_m';
			pal.icons($+1) = SCI + '/modules/xcos/images/palettes/'..
						+ block + '_m.png';

		elseif isfile(SCI + '/modules/xcos/images/palettes/'..
						+ block + '_f.png') then
			pal.blockNames($+1) = block+'_f';
			pal.icons($+1) = SCI + '/modules/xcos/images/palettes/'..
						+ block + '_f.png';

		else..
			pal.blockNames($+1) = block;
			pal.icons($+1) = SCI + '/modules/xcos/images/palettes/'..
						+ block + '.png';
		end
		pal.style($+1) = '';
	end

	for block = Pal_Style(:,1)'
		pal.blockNames($+1) = block;
		pal.icons($+1) = fullpath(pathconvert(Pal_Dir..
								+ '../../images/png'..
								+ filesep()..
								+ block + '.png',%f));
		pal.style($+1) = Pal_Style(..
							find(Pal_Style==block), 2);
	end

	if ~xcosPalAdd(pal) then
		error(msprintf(gettext("%s: Unable to export %s.\n"),..
								"ErturkMe - Xcos Module for Electrical Machines", "pal"));
	end
endfunction

LoadPalette();
clear LoadPalette;
