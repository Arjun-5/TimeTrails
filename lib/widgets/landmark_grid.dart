import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:time_trails/helpers/stylized_text.dart';
import 'package:time_trails/models/landmark_distance.dart';
import 'package:time_trails/widgets/custom_box.dart';

class LandmarkGrid extends StatelessWidget {
  final List<LandmarkDistance> landmarks;

  const LandmarkGrid({super.key, required this.landmarks});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: landmarks.length,
      itemBuilder: (context, index) {
        final item = landmarks[index];
        final landmark = item.landmark;
        return FutureBuilder<String>(
          future: landmark.getPhotoUrl(),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: CustomBox(
                width: 200,
                height: 100,
                cornerRadius: 20,
                topSkewFactor: 20,
                bottomSkewFactor: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const Center(child: CircularProgressIndicator())
                    else if (snapshot.hasError)
                      const Text('Failed to load image.')
                    else if (snapshot.hasData)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!,
                          height: 60,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Text('No image available.'),
                    const SizedBox(height: 3),
                    StylizedText(
                      landmark.name,
                      textAlignment: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
