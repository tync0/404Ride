import 'package:flutter/material.dart';
import 'package:uber/core/extension.dart';
import 'package:uber/widget/history.dart';
import 'package:uber/widget/place_tag.dart';
import 'package:uber/widget/text_field.dart';

class DraggableWidget extends StatefulWidget {
  final TextEditingController startController;
  final TextEditingController destinationController;
  const DraggableWidget({
    super.key,
    required this.startController,
    required this.destinationController,
  });

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  final List<String> tagTitles = ['Home', 'Office'];
  final List<String> titles = [
    'Azerbaijan State Oil and Indus...',
    'Holberton School'
  ];
  final List<String> subtitles = [
    '183 Nizami St, Baku',
    '89 Ataturk avenue, Baku 1000'
  ];
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.47,
      expand: false,
      maxChildSize: 0.47,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Where are you going ?',
                        style: context.textStyle,
                      ),
                      const SizedBox(height: 20),
                      SearchField(
                        hint: 'Choose your start point',
                        textEditingController: widget.startController,
                        asset: 'assets/initial.svg',
                      ),
                      const SizedBox(height: 20),
                      SearchField(
                        hint: 'Choose your destination',
                        textEditingController: widget.destinationController,
                        asset: 'assets/pin.svg',
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return PlaceTag(
                              title: tagTitles[index],
                              selected: index == 0,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 15),
                          itemCount: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverList.separated(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return HistoryWidget(
                    title: titles[index],
                    subtitle: subtitles[index],
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}
