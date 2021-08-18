import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY = '454a327c0a9f45439e9a8baf88967487';
class NewsService with ChangeNotifier{

  List <Article> headlines =[];
  String _selectedCategory = 'business';

  bool _isLoading = true;

  List<Category> categories=[
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology')
  ];

  Map<String,List<Article>> categoryArticles={

  };

  NewsService(){
    this.getTopHeadlines();

    categories.forEach((item) {
      this.categoryArticles[item.name] =  [];
    });
  }

  bool get isLoading => this._isLoading;

  get selectedCategory =>this._selectedCategory;
  set selectedCategory(String valor){
    this._selectedCategory = valor;

    this._isLoading = true;

    this.getArticlesByCategory(valor);
    notifyListeners();
  }
  List<Article> get getArticulosCategoriaSeleccionada =>this.categoryArticles[this.selectedCategory];



  getTopHeadlines() async{
    
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us';
    final resp = await http.get(Uri.parse(url));

    final newsResponse = newsResponseFromJson(resp.body);
    
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category)async{

    if(this.categoryArticles[category].length>0){
      this._isLoading = false;
      notifyListeners();
      return this.categoryArticles[category];
    }

    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us&category=$category';
    final resp = await http.get(Uri.parse(url));

    final newsResponse = newsResponseFromJson(resp.body);
    this.categoryArticles[category].addAll(newsResponse.articles);
    
    this._isLoading = false;
    notifyListeners();
  }
}