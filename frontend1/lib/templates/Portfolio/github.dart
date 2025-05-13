
/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class OpenSourceContributions extends StatefulWidget {
  @override
  _OpenSourceContributionsState createState() => _OpenSourceContributionsState();
}

class _OpenSourceContributionsState extends State<OpenSourceContributions> {
  final String githubUsername = 'Razan-kh';
  List<Repository> repositories = [];
  List<Commit> commits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGitHubStats();
  }

  // Fetch GitHub stats (repositories, commits, etc.)
  Future<void> fetchGitHubStats() async {
    final reposResponse = await http.get(Uri.parse('https://api.github.com/users/$githubUsername/repos'));
    if (reposResponse.statusCode == 200) {
      List jsonResponse = json.decode(reposResponse.body);
      setState(() {
        repositories = jsonResponse
            .map((repo) => Repository.fromJson(repo))
            .toList();
      });
    }

    // Fetch commits for each repository
    for (var repo in repositories) {
      final commitsResponse = await http.get(Uri.parse('https://api.github.com/repos/$githubUsername/${repo.name}/commits'));
      if (commitsResponse.statusCode == 200) {
        List commitData = json.decode(commitsResponse.body);
        commits.addAll(commitData.map((commit) => Commit.fromJson(commit)).toList());
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  // Launch URL function for repositories
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open-Source Contributions'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GitHub Contributions',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...repositories.map((repo) {
                      return _buildRepositoryCard(repo);
                    }).toList(),
                    SizedBox(height: 16),
                 /*   Text(
                      'Commit Timeline',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    _buildCommitTimeline(commits),
                    */
                  ],
                ),
              ),
            ),
    );
  }

  // Build repository card
  Widget _buildRepositoryCard(Repository repo) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          repo.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Contributions: ${repo.contributorsCount}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge Example for CI/CD, you can replace with your badge image URL
            Image.network(
              'https://img.shields.io/github/actions/workflow/status/${githubUsername}/${repo.name}/ci.yml',
              height: 25,
            ),
            IconButton(
              icon: Icon(Icons.link),
              onPressed: () => _launchURL(repo.htmlUrl),
            ),
          ],
        ),
      ),
    );
  }
/*
  // Build commit timeline
  Widget _buildCommitTimeline(List<Commit> commits) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(), // Disable internal scrolling for ListView
      shrinkWrap: true, // Allow ListView to be wrapped by SingleChildScrollView
      itemCount: commits.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.commit),
          title: Text(commits[index].message),
          subtitle: Text('Date: ${commits[index].date}'),
        );
      },
    );
  }
  */
}

// Model for GitHub Repository Data
class Repository {
  final String name;
  final String htmlUrl;
  final int contributorsCount;

  Repository({required this.name, required this.htmlUrl, required this.contributorsCount});

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      htmlUrl: json['html_url'],
      contributorsCount: json['contributors_count'] ?? 0,
    );
  }
}

// Model for Commit Data
class Commit {
  final String message;
  final String date;

  Commit({required this.message, required this.date});

  factory Commit.fromJson(Map<String, dynamic> json) {
    return Commit(
      message: json['commit']['message'],
      date: json['commit']['committer']['date'],
    );
  }
}
*/