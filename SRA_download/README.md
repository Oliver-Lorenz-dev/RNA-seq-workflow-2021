Downloading data from the sequence read archive (SRA) can be difficult. 

I have made two scripts in this repo that may make downloading data easier.

This method uses SRA explorer (https://sra-explorer.info/).

You need get the SRP number from your SRA dataset and search this SRP number in the SRA explorer. 

Then, copy the raw data download URLs (the first box that comes up) into a text file.

Then, download the two scripts and put them in the same directory as your text file with the data URLs in it.

Finally, run the download.sh script with your URL .txt file as an argument (e.g. `download.sh urls.txt`).

I uploaded a short video of me running this method, it may be helpful for you to watch the video: https://youtu.be/rhtTw_8neek

(This method only works if you can access the raw data download URLs from somewhere)
