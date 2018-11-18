# emoji-search
This project is for building and deploying an application called emoji search on AWS. To do this please follow the following steps:

Step1: Clone the github project https://github.com/ahfarmer/emoji-search.git 
Step2: Creat a new github project 'emoji' in own account
Step3: Clone the newly guthub project https://github.com/AbhishekGupta1506/emoji.git
Step4: Added the code from https://github.com/ahfarmer/emoji-search.git to own project
Step5: create a Dockerfile which extend the node base image then add the source code into the image, run the npm command to install the app and expose port 3000
Step6: Created an .dockerignore. It contains list of the files name which need to be ignore which copying cource code to docker image
Step7: Created a Build Specification File buildspec.yml. The build specification does the following:
	a. Pre-build stage:
		Log in to Amazon ECR.
		Set the repository URI to your ECR image and add an image tag with the first seven characters of the Git commit ID of the source.
	b. Build stage:
		Build the Docker image and tag the image both as latest and with the Git commit ID.
	c. Post-build stage:
		Push the image to your ECR repository with both tags.
		Write a file called emoji.json in the build root that has your Amazon ECS service's container name and the image and tag. The deployment stage of my CD pipeline uses this information to create a new revision of your service's task definition, and then it updates the service to use the new task definition. The emoji.json file is required for the AWS CodeDeploy ECS job worker.
Step8: Created an Amazon Elastic Container Service (Amazon ECS) cluster named emoji
	a. Open Amazon ECS
	b. Click Clusters and select Create Cluster button
	c. provide the Cluster name emoji keep everything default and then hit Create
	d. It will create a cluster
Step9: Create an AWS CodePipeline using the following details:
	a. Choose pipeline settings
		Pipeline settings
			Pipeline name
				emoji
			Artifact location
				codepipeline-us-east-1-151663058108
			Service role name
				AWSCodePipelineServiceRole-us-east-1-emoji
	b. Add source stage
		Source action provider
			ThirdParty GitHub
		PollForSourceChanges
			true
		Repo
			emoji
		Owner
			AbhishekGupta1506
		Branch
			master
	c. Add build stage
		Build action provider
			AWS CodeBuild
			choose Create a new build project
				ProjectName
					ecs-emoji
				Environment
					Use an image managed by AWS CodeBuild
				Operating system
					Ubuntu
				Runtime
					Docker
				Version
					aws/codebuild/docker:17.09.0
				Build specifiction
					Use the buildspec.yml in the source code root directory
	d. Add deploy stage
		Deploy action provider
		Deploy action provider
			AWS ECS
		ClusterName
			emoji
		ServiceName
			emoji-service
		FileName
			emoji.json
Step 10: Add Amazon ECR Permissions to the AWS CodeBuild Role codebuild-ecs-service-role
The AWS CodePipeline wizard created an IAM role for the AWS CodeBuild build project, called codebuild-ecs-service-role. Because the buildspec.yml file makes calls to Amazon ECR API operations, the role must have a policy that allows permissions to make these Amazon ECR calls. The following procedure helps you attach the proper permissions to the role.		
	a. open IAM console
	b. In the left navigation pane, choose Roles codebuild-ecs-service-role
	c. choose Attach policy
	d. Select the box to the left of the AmazonEC2ContainerRegistryPowerUser policy, and choose Attach policy
Step11: push all the change to github
Step12: Pipeline will be triggered for each commit/check-in to the github project
Step13: Verify the job from Codepipeline page