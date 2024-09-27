function obj = init(obj, varargin)
% 对 mphsolver 进行初始化
%   此处显示详细说明
    
    obj = get_param(obj);
    strs = split(obj.filename, '\');
    switch strs{end}
        case 'single_particle.mph'
            obj = single_particle(obj, varargin{:});
        case 'inclusion_1.mph'
            obj = inclusion_1(obj, varargin{:});
        case 'inclusion_1_hyp.mph'
            obj = inclusion_1_hyp(obj, varargin{:});
        case 'inclusion_2.mph'
            obj = inclusion_2(obj, varargin{:});
        case 'inclusion_2_主体是氯化银-银斑块散布.mph'
            obj = inclusion_2(obj, varargin{:});
        case 'core_shell.mph'
            obj = core_shell(obj, varargin{:});
        case 'core_shell_free_space.mph'
            obj = core_shell_free_space(obj, varargin{:});
        case 'nanorod.mph'
            obj = nanorod(obj, varargin{:});
    end

end







