configfile: 'merge_samplesheets.yaml'
output_root=config['output_folder']

rule all:
	input:
		out_config=output_root+'/merge_samplesheets.yaml',
		out_snakemake=output_root+'/merge_samplesheets.smk',
		sample_sheet=output_root+'/'+config['output_sheet'],
		merged_fastq=output_root+'/mergedfastq'

rule copy_files:
	input:
		in_config='merge_samplesheets.yaml',
		in_snakemake='merge_samplesheets.smk'
	output:
		out_config=output_root+'/merge_samplesheets.yaml',
		out_snakemake=output_root+'/merge_samplesheets.smk'
	shell:
		'''
		cp {input.in_config} {output.out_config}
		cp {input.in_snakemake} {output.out_snakemake}
		'''

rule merge_sheets:
	'''
	Even when set not to output fastq files, it still creates an empty fastq
	directory, so I had it create the directory in the correct location
	(as a parameter to avoid conflict with merge_fastqs)
	'''
	input:
		sample_list=expand(config['prefix']+'/{sample}', sample=config['samples'])
	params:
		merge_script=config['prefix']+'/'+config['merge_script'],
		operation='merge_sampleset',
		sample_set=config['sample_set'],
		probe=config['probe'],
		add_columns=config['add_columns'],
		exclude_columns=config['exclude_columns'],
		fastq_folder=output_root+'/mergedfastq'
	output:
		sample_sheet=output_root+'/'+config['output_sheet'],
	run:
		import subprocess
		command_string=f'python3 {params.merge_script} {params.operation} --set {params.sample_set}'
		for sample in input.sample_list:
			command_string+=f' --sheet {sample}'
		command_string+=f' --probe {params.probe} --mergeon sample_name-sample_set --skipfastqwrite --ignorereplicateredundancy'
		for add_column in params.add_columns:
			command_string+=f' --addcolumn {add_column}'
		for exclude_column in params.exclude_columns:
			command_string+=f' --exclude {exclude_column}'
		command_string+=f' --newsheet {output.sample_sheet} --newfastqdir {params.fastq_folder}'
		print(command_string)
		subprocess.call(command_string, shell=True)

rule merge_fastqs:
	'''
	merges the fastq files using paths from the sample sheet
	'''
	input:
		sample_sheet=output_root+'/'+config['output_sheet']
	params:
		merge_script=config['prefix']+'/'+config['merge_script'],
		operation='merge_sampleset_write_fastq'
	output:
		merged_fastq=directory(output_root+'/mergedfastq')
	shell:
		'python3 {params.merge_script} {params.operation} --mergedsheet {input.sample_sheet} --newfastqdir {output.merged_fastq} --skipbadfastqs'
		
