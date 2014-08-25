function LoadPalette()

	if exists("scicos_diagram", 'a') == 0 then loadXcosLibs(); end
	pal = xcosPal('StarGate - Palette for Controller');

	Pal_Dir = get_absolute_file_path('load_palette.sce');

	Pal_Style = [..
					'xcpl_BLSC',..
					'blockWithLabel;verticalLabelPosition=middle;spacing=15;'..
						+ 'displayedLabel='..
						+ '<table>'..
						+	'<tr>'..
						+		'<td>I_abc</td>'..
						+		'<th rowspan=""5"">BLSC</th>'..
						+		'<td>Va</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>wr</td>'..
						+		'<td></td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>theta</td>'..
						+		'<td>Vb</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>mode</td>'..
						+		'<td></td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>w*</td>'..
						+		'<td>Vc</td>'..
						+	'</tr>'..
						+ '</table>;';

					'xcpl_PMSC',..
					'blockWithLabel;verticalLabelPosition=middle;spacing=15;'..
						+ 'displayedLabel='..
						+ '<table>'..
						+	'<tr>'..
						+		'<td>I_dq</td>'..
						+		'<th rowspan=""4"">PMSC</th>'..
						+		'<td>Vd</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>wr</td>'..
						+		'<td></td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>theta</td>'..
						+		'<td></td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>w*</td>'..
						+		'<td>Vq</td>'..
						+	'</tr>'..
						+ '</table>;';
						
					'xcpl_PSDINV',..
					'blockWithLabel;verticalLabelPosition=middle;spacing=15;'..
						+ 'displayedLabel='..
						+ '<table>'..
						+	'<tr>'..
						+		'<td>t_abc</td>'..
						+		'<th rowspan=""2"">PSDINV</th>'..
						+		'<td>Vd</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>Vdc</td>'..
						+		'<td>Vq</td>'..
						+	'</tr>'..
						+ '</table>;';

					'xcpl_SVPWM',..
					'blockWithLabel;verticalLabelPosition=middle;spacing=15;'..
						+ 'displayedLabel='..
						+ '<table>'..
						+	'<tr>'..
						+		'<td>V_dq</td>'..
						+		'<th rowspan=""3"">PMSM</th>'..
						+		'<td>ta</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td></td>'..
						+		'<td>tb</td>'..
						+	'</tr>'..
						+	'<tr>'..
						+		'<td>Vdc</td>'..
						+		'<td>tc</td>'..
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
								"StarGate - Xcos Module for Electrical Machines", "pal"));
	end
endfunction

LoadPalette();
clear LoadPalette;

