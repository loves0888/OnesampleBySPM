%-----------------------------------------------------------------------
% Job saved on 24-Jun-2024 09:42:21 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
clear;
clc;
path = 'G:\LC\Meditation_resting\preprocessing\AFNI_smooth_regress_fc';
tmp = dir(path);
tmp = tmp(3:end);
conname = 'correlations_matrix_MNI152NLin2009cAsym';
data = {};
for i = 1:numel(tmp)
    sub = fullfile(path, tmp(i).name);
    
    for k = 1:10
        subnii = fullfile(sub, strcat(conname,'_',num2str(k),'.nii,1'));
        data{i,k} = subnii;
        outpath = fullfile('G:\LC\Meditation_resting\results', strcat('SPMresult','_',num2str(k)));
        mkdir(outpath);
    end
    
end


for i = 1:10

    niidata = data(:,i);


    spm_jobman('initcfg');
    matlabbatch{1}.spm.stats.factorial_design.dir = {fullfile('G:\LC\Meditation_resting\results', strcat('SPMresult','_',num2str(i)))};
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = niidata;
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {'G:\LC\Meditation_resting\code\atlas\mni_icbm152_nlin_asym_09c\Tr_mni_icbm152_t1_tal_nlin_asym_09c_mask.nii,1'};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    
    spm_jobman('initcfg');
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {fullfile('G:\LC\Meditation_resting\results', strcat('SPMresult','_',num2str(i)), 'SPM.mat')};
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch);
    clear matlabbatch

end
