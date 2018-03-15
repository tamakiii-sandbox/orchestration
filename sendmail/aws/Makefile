profile             := tamakiii
region              := ap-northeast-1
aws                 := aws --profile $(profile) --region $(region)
cluster             := sendmail
service             := sendmail
family              := sendmail
latest_task_def_arn ?= $(shell make latest-task-definition-arn --silent)

login:
	$(shell $(aws) ecr get-login --no-include-email)

deploy:
	$(aws) ecs update-service \
		--cluster $(cluster) \
		--service $(service) \
		--task-definition $(latest_task_def_arn) \
		--force-new-deployment \
		| jq '.'

latest-task-definition-arn:
	$(aws) ecs list-task-definitions --family-prefix $(family) --sort DESC --query 'taskDefinitionArns[0]' --output text

task-definition-arns:
	$(aws) ecs list-task-definitions --family-prefix $(family) --sort DESC
