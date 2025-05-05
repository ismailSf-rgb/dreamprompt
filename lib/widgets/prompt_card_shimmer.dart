import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PromptCardShimmer extends StatelessWidget {
  const PromptCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header shimmer
              Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundColor: Colors.white),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 60,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Content shimmer
              Container(
                width: double.infinity,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: 200,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              
              // Footer shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Container(
                    width: 80,
                    height: 24,
                    color: Colors.white,
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}