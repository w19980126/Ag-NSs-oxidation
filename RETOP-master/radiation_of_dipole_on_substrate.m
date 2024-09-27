function out = model
%
% radiation_of_dipole_on_substrate.m
%
% Model exported on May 12 2023, 14:59 by COMSOL 6.0.0.318.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('D:\DeskTop\desktop\SPR_DF\Microscope_Image_Calcu\RETOP-master\RETOP-master');

model.label('radiation_of_dipole_on_substrate.mph');

model.param.set('dwater', '500[nm]', [native2unicode(hex2dec({'6c' '34'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'53' '9a'}), 'unicode')  native2unicode(hex2dec({'5e' 'a6'}), 'unicode') ]);
model.param.set('dglass', '500[nm]', [native2unicode(hex2dec({'73' 'bb'}), 'unicode')  native2unicode(hex2dec({'74' '83'}), 'unicode')  native2unicode(hex2dec({'53' '9a'}), 'unicode')  native2unicode(hex2dec({'5e' 'a6'}), 'unicode') ]);
model.param.set('lamda', '660[nm]', [native2unicode(hex2dec({'6c' 'e2'}), 'unicode')  native2unicode(hex2dec({'95' '7f'}), 'unicode') ]);
model.param.set('f', 'c_const/lamda', [native2unicode(hex2dec({'98' '91'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') ]);
model.param.set('w', '500[nm]', [native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'77' '1f'}), 'unicode')  native2unicode(hex2dec({'5c' '3a'}), 'unicode')  native2unicode(hex2dec({'5e' 'a6'}), 'unicode') ]);
model.param.set('nwater', '1.33', [native2unicode(hex2dec({'6c' '34'}), 'unicode')  native2unicode(hex2dec({'62' '98'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') ]);
model.param.set('nglass', '1.55', [native2unicode(hex2dec({'73' 'bb'}), 'unicode')  native2unicode(hex2dec({'74' '83'}), 'unicode')  native2unicode(hex2dec({'62' '98'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') ]);
model.param.set('d', '1[nm]', [native2unicode(hex2dec({'50' '76'}), 'unicode')  native2unicode(hex2dec({'67' '81'}), 'unicode')  native2unicode(hex2dec({'5b' '50'}), 'unicode')  native2unicode(hex2dec({'8d' 'dd'}), 'unicode')  native2unicode(hex2dec({'79' 'bb'}), 'unicode')  native2unicode(hex2dec({'75' '4c'}), 'unicode')  native2unicode(hex2dec({'97' '62'}), 'unicode')  native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'9a' 'd8'}), 'unicode')  native2unicode(hex2dec({'5e' 'a6'}), 'unicode') ]);
model.param.set('t_Box', '350[nm]');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 3);

model.result.table.create('tbl1', 'Table');
model.result.table.create('evl3', 'Table');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('blk1', 'Block');
model.component('comp1').geom('geom1').feature('blk1').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk1').set('size', {'w' 'w' 'dwater+dglass'});
model.component('comp1').geom('geom1').feature('blk1').set('layername', {[native2unicode(hex2dec({'5c' '42'}), 'unicode') ' 1']});
model.component('comp1').geom('geom1').feature('blk1').setIndex('layer', 'dglass', 0);
model.component('comp1').geom('geom1').create('pt1', 'Point');
model.component('comp1').geom('geom1').feature('pt1').set('p', {'0' '0' 'd'});
model.component('comp1').geom('geom1').create('blk2', 'Block');
model.component('comp1').geom('geom1').feature('blk2').set('base', 'center');
model.component('comp1').geom('geom1').feature('blk2').set('size', {'t_Box' 't_Box' 't_Box'});
model.component('comp1').geom('geom1').feature('blk2').set('layerbottom', false);
model.component('comp1').geom('geom1').run;

model.component('comp1').selection.create('sel1', 'Explicit');
model.component('comp1').selection('sel1').geom('geom1', 0);
model.component('comp1').selection('sel1').set([13]);
model.component('comp1').selection('sel1').label([native2unicode(hex2dec({'50' '76'}), 'unicode')  native2unicode(hex2dec({'67' '81'}), 'unicode')  native2unicode(hex2dec({'5b' '50'}), 'unicode') ]);

model.view.create('view2', 3);

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material.create('mat2', 'Common');
model.component('comp1').material('mat1').propertyGroup.create('RefractiveIndex', [native2unicode(hex2dec({'62' '98'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') ]);
model.component('comp1').material('mat2').selection.set([1 3]);
model.component('comp1').material('mat2').propertyGroup.create('RefractiveIndex', [native2unicode(hex2dec({'62' '98'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') ]);

model.component('comp1').physics.create('ewfd', 'ElectromagneticWavesFrequencyDomain', 'geom1');
model.component('comp1').physics('ewfd').create('epd1', 'ElectricPointDipole', 0);
model.component('comp1').physics('ewfd').feature('epd1').selection.set([13]);
model.component('comp1').physics('ewfd').create('sctr1', 'Scattering', 2);
model.component('comp1').physics('ewfd').feature('sctr1').selection.set([1 2 3 4 5 7 8 9 21 22]);

model.component('comp1').mesh('mesh1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').create('size2', 'Size');
model.component('comp1').mesh('mesh1').create('ftet1', 'FreeTet');
model.component('comp1').mesh('mesh1').feature('size1').selection.geom('geom1', 3);
model.component('comp1').mesh('mesh1').feature('size1').selection.set([1 3]);
model.component('comp1').mesh('mesh1').feature('size2').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('size2').selection.set([10 11 12 13 14 16 17 18 19 20]);

model.result.table('tbl1').comments([native2unicode(hex2dec({'70' 'b9'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 1']);
model.result.table('evl3').label('Evaluation 3D');
model.result.table('evl3').comments([native2unicode(hex2dec({'4e' 'a4'}), 'unicode')  native2unicode(hex2dec({'4e' '92'}), 'unicode')  native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'4e' '09'}), 'unicode')  native2unicode(hex2dec({'7e' 'f4'}), 'unicode')  native2unicode(hex2dec({'50' '3c'}), 'unicode') ]);

model.component('comp1').view('view1').set('renderwireframe', true);
model.component('comp1').view('view1').set('transparency', true);

model.component('comp1').material('mat1').label('water');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', {'nwater' '0' '0' '0' 'nwater' '0' '0' '0' 'nwater'});
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
model.component('comp1').material('mat2').label('glass');
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('n', '');
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('ki', '');
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('n', '');
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('ki', '');
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('n', {'nglass' '0' '0' '0' 'nglass' '0' '0' '0' 'nglass'});
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});

model.component('comp1').physics('ewfd').prop('MeshControl').set('SizeControlParameter', 'UserDefined');
model.component('comp1').physics('ewfd').prop('MeshControl').set('PhysicsControlledMeshMaximumElementSize', 'lamda/6/nglass');
model.component('comp1').physics('ewfd').feature('epd1').set('DipoleSpecification', 'DipoleMoment');
model.component('comp1').physics('ewfd').feature('epd1').set('pI', [0; 0; 1]);

model.component('comp1').mesh('mesh1').feature('size').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size').set('hmax', '5.3360E-8');
model.component('comp1').mesh('mesh1').feature('size').set('hmin', '1.6010E-9');
model.component('comp1').mesh('mesh1').feature('size1').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size1').set('hmax', '4.5790E-8');
model.component('comp1').mesh('mesh1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hmin', '1.3740E-9');
model.component('comp1').mesh('mesh1').feature('size1').set('hminactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hcurveactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hnarrowactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hgradactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hauto', 1);
model.component('comp1').mesh('mesh1').run;

model.study.create('std1');
model.study('std1').create('freq', 'Frequency');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').create('i2', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i2').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature.remove('fcDef');

model.result.numerical.create('pev1', 'EvalPoint');
model.result.numerical('pev1').set('probetag', 'none');
model.result.create('pg5', 'PlotGroup3D');
model.result('pg5').create('rp1', 'RadiationPattern');
model.result('pg5').feature('rp1').set('expr', 'ewfd.normEfar');

model.study('std1').feature('freq').set('plist', 'f');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label([native2unicode(hex2dec({'7f' '16'}), 'unicode')  native2unicode(hex2dec({'8b' 'd1'}), 'unicode')  native2unicode(hex2dec({'65' 'b9'}), 'unicode')  native2unicode(hex2dec({'7a' '0b'}), 'unicode') ': ' native2unicode(hex2dec({'98' '91'}), 'unicode')  native2unicode(hex2dec({'57' 'df'}), 'unicode') ]);
model.sol('sol1').feature('v1').label([native2unicode(hex2dec({'56' 'e0'}), 'unicode')  native2unicode(hex2dec({'53' 'd8'}), 'unicode')  native2unicode(hex2dec({'91' 'cf'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('v1').set('clistctrl', {'p1'});
model.sol('sol1').feature('v1').set('cname', {'freq'});
model.sol('sol1').feature('v1').set('clist', {'f'});
model.sol('sol1').feature('s1').label([native2unicode(hex2dec({'7a' '33'}), 'unicode')  native2unicode(hex2dec({'60' '01'}), 'unicode')  native2unicode(hex2dec({'6c' '42'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('s1').feature('dDef').label([native2unicode(hex2dec({'76' 'f4'}), 'unicode')  native2unicode(hex2dec({'63' 'a5'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('aDef').label([native2unicode(hex2dec({'9a' 'd8'}), 'unicode')  native2unicode(hex2dec({'7e' 'a7'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature('p1').label([native2unicode(hex2dec({'53' 'c2'}), 'unicode')  native2unicode(hex2dec({'65' '70'}), 'unicode')  native2unicode(hex2dec({'53' '16'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'THz'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('fc1').label([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'80' '26'}), 'unicode')  native2unicode(hex2dec({'54' '08'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature('i1').label([native2unicode(hex2dec({'5e' 'fa'}), 'unicode')  native2unicode(hex2dec({'8b' 'ae'}), 'unicode')  native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'8f' 'ed'}), 'unicode')  native2unicode(hex2dec({'4e' 'e3'}), 'unicode')  native2unicode(hex2dec({'6c' '42'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' (ewfd)']);
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature('ilDef').label([native2unicode(hex2dec({'4e' '0d'}), 'unicode')  native2unicode(hex2dec({'5b' '8c'}), 'unicode')  native2unicode(hex2dec({'51' '68'}), 'unicode') ' LU ' native2unicode(hex2dec({'52' '06'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').label([native2unicode(hex2dec({'59' '1a'}), 'unicode')  native2unicode(hex2dec({'91' 'cd'}), 'unicode')  native2unicode(hex2dec({'7f' '51'}), 'unicode')  native2unicode(hex2dec({'68' '3c'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').label([native2unicode(hex2dec({'98' '84'}), 'unicode')  native2unicode(hex2dec({'5e' '73'}), 'unicode')  native2unicode(hex2dec({'6e' 'd1'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').label('SOR Vector 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').label([native2unicode(hex2dec({'54' '0e'}), 'unicode')  native2unicode(hex2dec({'5e' '73'}), 'unicode')  native2unicode(hex2dec({'6e' 'd1'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').label('SOR Vector 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').label([native2unicode(hex2dec({'7c' '97'}), 'unicode')  native2unicode(hex2dec({'53' '16'}), 'unicode')  native2unicode(hex2dec({'6c' '42'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('dDef').label([native2unicode(hex2dec({'76' 'f4'}), 'unicode')  native2unicode(hex2dec({'63' 'a5'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('i2').label([native2unicode(hex2dec({'5e' 'fa'}), 'unicode')  native2unicode(hex2dec({'8b' 'ae'}), 'unicode')  native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'8f' 'ed'}), 'unicode')  native2unicode(hex2dec({'4e' 'e3'}), 'unicode')  native2unicode(hex2dec({'6c' '42'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' (ewfd) 2']);
model.sol('sol1').feature('s1').feature('i2').set('linsolver', 'fgmres');
model.sol('sol1').feature('s1').feature('i2').feature('ilDef').label([native2unicode(hex2dec({'4e' '0d'}), 'unicode')  native2unicode(hex2dec({'5b' '8c'}), 'unicode')  native2unicode(hex2dec({'51' '68'}), 'unicode') ' LU ' native2unicode(hex2dec({'52' '06'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').label([native2unicode(hex2dec({'59' '1a'}), 'unicode')  native2unicode(hex2dec({'91' 'cd'}), 'unicode')  native2unicode(hex2dec({'7f' '51'}), 'unicode')  native2unicode(hex2dec({'68' '3c'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').label([native2unicode(hex2dec({'98' '84'}), 'unicode')  native2unicode(hex2dec({'5e' '73'}), 'unicode')  native2unicode(hex2dec({'6e' 'd1'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sv1').label('SOR Vector 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').label([native2unicode(hex2dec({'54' '0e'}), 'unicode')  native2unicode(hex2dec({'5e' '73'}), 'unicode')  native2unicode(hex2dec({'6e' 'd1'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sv1').label('SOR Vector 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('cs').label([native2unicode(hex2dec({'7c' '97'}), 'unicode')  native2unicode(hex2dec({'53' '16'}), 'unicode')  native2unicode(hex2dec({'6c' '42'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('cs').feature('dDef').label([native2unicode(hex2dec({'76' 'f4'}), 'unicode')  native2unicode(hex2dec({'63' 'a5'}), 'unicode') ' 1']);
model.sol('sol1').runAll;

model.result.numerical('pev1').set('table', 'tbl1');
model.result.numerical('pev1').set('expr', {'ewfd.omega' 'c_const'});
model.result.numerical('pev1').set('unit', {'rad/s' 'm/s'});
model.result.numerical('pev1').set('descr', {[native2unicode(hex2dec({'89' 'd2'}), 'unicode')  native2unicode(hex2dec({'98' '91'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') ] [native2unicode(hex2dec({'77' '1f'}), 'unicode')  native2unicode(hex2dec({'7a' '7a'}), 'unicode')  native2unicode(hex2dec({'4e' '2d'}), 'unicode')  native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'51' '49'}), 'unicode')  native2unicode(hex2dec({'90' '1f'}), 'unicode') ]});
model.result.numerical('pev1').setResult;
model.result('pg5').label([native2unicode(hex2dec({'75' '35'}), 'unicode')  native2unicode(hex2dec({'57' '3a'}), 'unicode') ' (ewfd)']);
model.result('pg5').set('view', 'view2');
model.result('pg5').feature('rp1').set('unit', 'V/m');
model.result('pg5').feature('rp1').set('descr', [native2unicode(hex2dec({'8f' 'dc'}), 'unicode')  native2unicode(hex2dec({'57' '3a'}), 'unicode')  native2unicode(hex2dec({'6a' '21'}), 'unicode') ]);
model.result('pg5').feature('rp1').set('thetadisc', 100);
model.result('pg5').feature('rp1').set('phidisc', 100);

model.label('radiation_of_dipole_on_substrate.mph');

out = model;
