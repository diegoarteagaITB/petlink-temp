import 'package:flutter/material.dart';

class SearchViewFilterPets extends StatefulWidget {
  const SearchViewFilterPets(
      {Key? key, petList, required this.onSearchTextChanged})
      : super(key: key);

  final void Function(String) onSearchTextChanged;
  @override
  State<SearchViewFilterPets> createState() => _SearchViewFilterPetsState();
}

class _SearchViewFilterPetsState extends State<SearchViewFilterPets> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: _textController,
        onChanged: (text) {
          Future.delayed(const Duration(milliseconds: 300), () {
            widget.onSearchTextChanged(text);
            print("Search text-------------->>: $text");
          });
        },
        decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: Color.fromARGB(255, 4, 40, 71),
            ),
            onPressed: () => FocusScope.of(context).unfocus(),
          ),
          hintText: 'Search by breed',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
