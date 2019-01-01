package main

import (
	"context"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"

	speech "cloud.google.com/go/speech/apiv1"
	speechpb "google.golang.org/genproto/googleapis/cloud/speech/v1"
)

func recognize(data []byte) (string, error) {
	ctx := context.Background()

	client, err := speech.NewClient(ctx)
	if err != nil {
		return "", err
	}

	// Send the contents of the audio file with the encoding and
	// and sample rate information to be transcripted.
	resp, err := client.Recognize(ctx, &speechpb.RecognizeRequest{
		Config: &speechpb.RecognitionConfig{
			LanguageCode: "en-US",
		},
		Audio: &speechpb.RecognitionAudio{
			AudioSource: &speechpb.RecognitionAudio_Content{Content: data},
		},
	})

	if err != nil {
		log.Fatal(err)
	}

	// Print the results.
	for _, result := range resp.Results {
		for _, alt := range result.Alternatives {
			return alt.Transcript, nil
		}
	}
	return "", nil
}

func postHandler(w http.ResponseWriter, r *http.Request) {
	recBin, _ := ioutil.ReadAll(r.Body)
	defer r.Body.Close()

	ret, _ := recognize(recBin)
	fmt.Println(ret)
	io.WriteString(w, ret)
}

func main() {
	http.HandleFunc("/", postHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
