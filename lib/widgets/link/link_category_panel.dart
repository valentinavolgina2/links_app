import 'package:flutter/material.dart';

import '../../model/link.dart';
import '../../styles/size.dart';
import '../list/list.dart';
import 'link.dart';

ExpansionPanel categoryExpansionPanel(
    {required CategoryExpansionPanel category,
    required List<Link> links,
    required Set<String> tagFilters,
    required List<String> allTags,
    required List<String> allCategories}) {
  final linksFilteredByCategoryAndTags = links
      .where((link) => link.category == category.header)
      .where((link) => tagFilters.isEmpty
          ? true
          : link.tags.toSet().containsAll(tagFilters));

  return ExpansionPanel(
      headerBuilder: (context, isExpanded) {
        final filteredLinksCount = linksFilteredByCategoryAndTags.length;
        final completedLinksCount = linksFilteredByCategoryAndTags
            .where((link) => link.completed)
            .toList()
            .length;

        final categoryName =
            category.header == '' ? 'No category' : category.header;

        return Padding(
          padding: EdgeInsets.all(AppSizes.medium),
          child: Text(
              '$categoryName ($completedLinksCount/$filteredLinksCount done)'),
        );
      },
      body: ListView(shrinkWrap: true, children: <Widget>[
        ...linksFilteredByCategoryAndTags
            .map((link) => LinkContainer(
                link: link, listTags: allTags, listCategories: allCategories))
            .toList(),
      ]),
      isExpanded: category.isExpanded);
}
