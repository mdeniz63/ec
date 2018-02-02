echo "Dont forget ChangeLogs!"

# Version info
echo -e "\n"
echo "What is the version?"
read -p "version :" version

#docker exec -it ec /bin/bash -c "echo $version > VERSION"

# Login Docker Hub
echo "Login Docker Hub"
docker login -u mdeniz63

docker push mdeniz63/ec:latest
docker push mdeniz63/ec:$version

