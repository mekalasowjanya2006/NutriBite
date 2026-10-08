import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const NutriBiteApp());
}

// ============================================================
// APP
// ============================================================

class NutriBiteApp extends StatelessWidget {
  const NutriBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriBite',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFFF8F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ============================================================
// SPLASH SCREEN
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange,
              Color(0xFFFF7043),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        '🍽️',
                        style: TextStyle(fontSize: 55),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'NutriBite',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Taste it. Know it. Love it.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 35),
                  const SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LOGIN SCREEN
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  '🍽️',
                  style: TextStyle(fontSize: 70),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Welcome to NutriBite',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Order food. Know your nutrition.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }

                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset link sent!'),
                        ),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sign Up feature coming soon!'),
                      ),
                    );
                  },
                  child: const Text(
                    'New user? Create an account',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning! 👋';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon! 👋';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening! 👋';
    } else {
      return 'Good Night! 🌙';
    }
  }

  String selectedCategory = 'All';

  final List<Map<String, dynamic>> foods = [
    {
      'name': 'Margherita Pizza',
      'price': 199,
      'rating': 4.8,
      'calories': 280,
      'category': 'Pizza',
      'image':
          'https://commons.wikimedia.org/wiki/Special:FilePath/Pizza_Margherita_01.jpg',
    },
    {
      'name': 'Chicken Burger',
      'price': 149,
      'rating': 4.7,
      'calories': 350,
      'category': 'Burger',
      'image': 'https://fendifood.com/images/burgers/chicken-burger-new.png',
    },
    {
      'name': 'Chicken Biryani',
      'price': 249,
      'rating': 4.9,
      'calories': 520,
      'category': 'Biryani',
      'image':
          'https://cf-img-a-in.tosshub.com/sites/visualstory/wp/2023/08/Chicken-Biryani-Recipe.jpg',
    },
    {
      'name': 'Hakka Noodles',
      'price': 179,
      'rating': 4.6,
      'calories': 410,
      'category': 'Noodles',
      'image':
          'https://media-assets.swiggy.com/swiggy/image/upload/f_auto,q_auto,fl_lossy/kkryoyykqtvol5larqd7',
    },
    {
      'name': 'Healthy Salad',
      'price': 129,
      'rating': 4.5,
      'calories': 180,
      'category': 'Healthy',
      'image':
          'https://commons.wikimedia.org/wiki/Special:FilePath/Healthy_salad.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFoods = selectedCategory == 'All'
        ? foods
        : foods
            .where(
              (food) => food['category'] == selectedCategory,
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NutriBite',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'What would you like to eat today?',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search food...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  'All',
                  'Pizza',
                  'Burger',
                  'Biryani',
                  'Noodles',
                  'Healthy',
                ].map(
                  (category) {
                    final isSelected = selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: Colors.orange,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Popular Foods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...filteredFoods.map(
              (food) => FoodCard(
                name: food['name'],
                price: food['price'],
                rating: food['rating'],
                calories: food['calories'],
                imageUrl: food['image'],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FOOD CARD
// ============================================================

class FoodCard extends StatefulWidget {
  final String name;
  final int price;
  final double rating;
  final int calories;
  final String imageUrl;

  const FoodCard({
    super.key,
    required this.name,
    required this.price,
    required this.rating,
    required this.calories,
    required this.imageUrl,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailsScreen(
                name: widget.name,
                price: widget.price,
                rating: widget.rating,
                calories: widget.calories,
                imageUrl: widget.imageUrl,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.imageUrl,
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 95,
                      height: 95,
                      color: Colors.orange.shade100,
                      child: const Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.orange,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        Text(
                          ' ${widget.rating}',
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.red,
                          size: 18,
                        ),
                        Text(
                          ' ${widget.calories} kcal',
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '₹${widget.price}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${widget.name} added to cart',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.orange,
                    ),
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

// ============================================================
// FOOD DETAILS
// ============================================================

class FoodDetailsScreen extends StatelessWidget {
  final String name;
  final int price;
  final double rating;
  final int calories;
  final String imageUrl;

  const FoodDetailsScreen({
    super.key,
    required this.name,
    required this.price,
    required this.rating,
    required this.calories,
    required this.imageUrl,
  });

  String getDescription(String foodName) {
    switch (foodName) {
      case 'Margherita Pizza':
        return 'Classic Italian pizza with tomato sauce, mozzarella cheese and fresh basil.';
      case 'Chicken Burger':
        return 'Juicy chicken patty served with fresh vegetables, cheese and soft burger bun.';
      case 'Chicken Biryani':
        return 'Aromatic basmati rice cooked with tender chicken, spices and herbs.';
      case 'Hakka Noodles':
        return 'Delicious stir-fried noodles with fresh vegetables and flavorful sauces.';
      case 'Healthy Salad':
        return 'Fresh and healthy salad made with vegetables, sweet corn and lemon dressing.';
      default:
        return 'A delicious food item from NutriBite.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.orange.shade100,
                    child: const Icon(
                      Icons.restaurant,
                      size: 80,
                      color: Colors.orange,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                Text(
                  ' $rating',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.red,
                ),
                Text(
                  ' $calories kcal',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              getDescription(name),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.restaurant_menu,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Want to know what is inside this food?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NutritionScreen(
                            foodName: name,
                          ),
                        ),
                      );
                    },
                    child: const Text('View'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹$price',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$name added to cart',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// NUTRITION SCREEN
// ============================================================

class NutritionScreen extends StatelessWidget {
  final String foodName;

  const NutritionScreen({
    super.key,
    required this.foodName,
  });

  Map<String, dynamic> getFoodInfo() {
    switch (foodName) {
      case 'Margherita Pizza':
        return {
          'calories': 280,
          'protein': '12g',
          'carbs': '35g',
          'fat': '10g',
          'sugar': '5g',
          'sodium': '420mg',
          'ingredients': [
            'Pizza dough',
            'Tomato sauce',
            'Mozzarella',
            'Basil',
            'Olive oil',
            'Oregano',
          ],
          'allergens': ['Milk', 'Gluten'],
          'vegetarian': true,
        };

      case 'Chicken Burger':
        return {
          'calories': 350,
          'protein': '24g',
          'carbs': '32g',
          'fat': '16g',
          'sugar': '6g',
          'sodium': '650mg',
          'ingredients': [
            'Chicken patty',
            'Burger bun',
            'Lettuce',
            'Tomato',
            'Red onion',
            'Mayonnaise',
            'Cheese',
          ],
          'allergens': ['Gluten', 'Egg', 'Milk'],
          'vegetarian': false,
        };

      case 'Chicken Biryani':
        return {
          'calories': 520,
          'protein': '28g',
          'carbs': '62g',
          'fat': '18g',
          'sugar': '3g',
          'sodium': '780mg',
          'ingredients': [
            'Basmati rice',
            'Chicken',
            'Onion',
            'Yogurt',
            'Ginger',
            'Garlic',
            'Green chilli',
            'Mint',
            'Saffron',
            'Spices',
          ],
          'allergens': ['Milk'],
          'vegetarian': false,
        };

      case 'Hakka Noodles':
        return {
          'calories': 410,
          'protein': '10g',
          'carbs': '58g',
          'fat': '15g',
          'sugar': '7g',
          'sodium': '720mg',
          'ingredients': [
            'Hakka noodles',
            'Cabbage',
            'Carrot',
            'Capsicum',
            'Spring onion',
            'Garlic',
            'Soy sauce',
            'Chilli sauce',
          ],
          'allergens': ['Gluten', 'Soy'],
          'vegetarian': true,
        };

      default:
        return {
          'calories': 180,
          'protein': '6g',
          'carbs': '22g',
          'fat': '8g',
          'sugar': '7g',
          'sodium': '190mg',
          'ingredients': [
            'Lettuce',
            'Cucumber',
            'Tomato',
            'Carrot',
            'Sweet corn',
            'Red onion',
            'Pumpkin seeds',
            'Lemon dressing',
          ],
          'allergens': ['Seeds'],
          'vegetarian': true,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = getFoodInfo();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition & Ingredients'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              foodName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calories',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${info['calories']} kcal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nutrition Facts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: NutritionCard(
                    title: 'Protein',
                    value: info['protein'],
                    icon: Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: NutritionCard(
                    title: 'Carbs',
                    value: info['carbs'],
                    icon: Icons.grain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: NutritionCard(
                    title: 'Fat',
                    value: info['fat'],
                    icon: Icons.opacity,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: NutritionCard(
                    title: 'Sugar',
                    value: info['sugar'],
                    icon: Icons.cookie,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            NutritionCard(
              title: 'Sodium',
              value: info['sodium'],
              icon: Icons.water_drop,
            ),
            const SizedBox(height: 25),
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (info['ingredients'] as List)
                  .map(
                    (item) => Chip(
                      label: Text(item),
                      backgroundColor: Colors.orange.shade50,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 25),
            const Text(
              'Allergens',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...(info['allergens'] as List).map(
              (allergen) => ListTile(
                leading: const Icon(
                  Icons.warning_amber,
                  color: Colors.red,
                ),
                title: Text(allergen),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: info['vegetarian']
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(
                    info['vegetarian'] ? Icons.eco : Icons.no_food,
                    color: info['vegetarian'] ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    info['vegetarian'] ? 'Vegetarian' : 'Non-Vegetarian',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// NUTRITION CARD
// ============================================================

class NutritionCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const NutritionCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.orange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CART SCREEN
// ============================================================

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Chicken Biryani',
      'price': 249,
      'quantity': 1,
    },
    {
      'name': 'Hakka Noodles',
      'price': 179,
      'quantity': 1,
    },
  ];

  int get subtotal {
    int total = 0;

    for (var item in cartItems) {
      total += (item['price'] as int) * (item['quantity'] as int);
    }

    return total;
  }

  int get deliveryFee {
    return cartItems.isEmpty ? 0 : 40;
  }

  int get total {
    return subtotal + deliveryFee;
  }

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: Colors.orange,
                                  size: 35,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '₹${item['price']}',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      decreaseQuantity(index);
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Text(
                                    '${item['quantity']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      increaseQuantity(index);
                                    },
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  removeItem(index);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      billRow(
                        'Subtotal',
                        '₹$subtotal',
                      ),
                      const SizedBox(height: 8),
                      billRow(
                        'Delivery Fee',
                        '₹$deliveryFee',
                      ),
                      const Divider(height: 25),
                      billRow(
                        'Total',
                        '₹$total',
                        bold: true,
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddressScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget billRow(
    String title,
    String amount, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 18 : 15,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 20 : 15,
            color: bold ? Colors.orange : Colors.black,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ADDRESS SCREEN
// ============================================================

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final pinController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    pinController.dispose();
    super.dispose();
  }

  Widget field(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              field(
                'Full Name',
                nameController,
              ),
              field(
                'Phone Number',
                phoneController,
                keyboardType: TextInputType.phone,
              ),
              field(
                'House / Street Address',
                addressController,
              ),
              field(
                'City',
                cityController,
              ),
              field(
                'PIN Code',
                pinController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSummaryScreen(
                            name: nameController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                            city: cityController.text,
                            pin: pinController.text,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ORDER SUMMARY
// ============================================================

class OrderSummaryScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final String city;
  final String pin;

  const OrderSummaryScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.pin,
  });

  @override
  Widget build(BuildContext context) {
    const int biryani = 249;
    const int noodles = 179;
    const int delivery = 40;
    const int total = 468;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(phone),
                  const SizedBox(height: 5),
                  Text(address),
                  Text('$city - $pin'),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Your Order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            summaryRow(
              'Chicken Biryani',
              '₹$biryani',
            ),
            summaryRow(
              'Hakka Noodles',
              '₹$noodles',
            ),
            summaryRow(
              'Delivery Fee',
              '₹$delivery',
            ),
            const Divider(height: 30),
            summaryRow(
              'Total',
              '₹$total',
              bold: true,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Continue to Payment',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(
    String title,
    String amount, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 18 : 15,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 20 : 15,
              color: bold ? Colors.orange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PAYMENT SCREEN WITH QR
// ============================================================

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPayment = 'UPI';

  @override
  Widget build(BuildContext context) {
    const int amount = 468;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.orange,
                      Color(0xFFFF7043),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Amount to Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '₹468',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // UPI
              Card(
                child: RadioListTile<String>(
                  value: 'UPI',
                  groupValue: selectedPayment,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  },
                  title: const Text(
                    'UPI',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Pay using UPI apps',
                  ),
                  secondary: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.orange,
                  ),
                ),
              ),

              // QR APPEARS ONLY FOR UPI
              if (selectedPayment == 'UPI') ...[
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Scan QR to Pay',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Scan this QR using a UPI app',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orange,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: QrImageView(
                          data:
                              'upi://pay?pa=nutribite.demo@upi&pn=NutriBite&am=468&cu=INR',
                          version: QrVersions.auto,
                          size: 220,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '₹468',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Demo payment QR',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 15),

              // CARD
              Card(
                child: RadioListTile<String>(
                  value: 'Card',
                  groupValue: selectedPayment,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  },
                  title: const Text(
                    'Credit / Debit Card',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Visa, Mastercard, RuPay',
                  ),
                  secondary: const Icon(
                    Icons.credit_card,
                    color: Colors.orange,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // CASH
              Card(
                child: RadioListTile<String>(
                  value: 'Cash',
                  groupValue: selectedPayment,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  },
                  title: const Text(
                    'Cash on Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Pay when your food arrives',
                  ),
                  secondary: const Icon(
                    Icons.money,
                    color: Colors.orange,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderConfirmationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Place Order • ₹468',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ORDER CONFIRMATION
// ============================================================

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 70,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Order Confirmed!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your delicious food is on the way.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Order ID',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'NB10245',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderTrackingScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Track Order',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ORDER TRACKING
// ============================================================

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'title': 'Order Confirmed',
        'subtitle': 'Your order has been confirmed',
        'icon': Icons.check_circle,
      },
      {
        'title': 'Preparing Food',
        'subtitle': 'The restaurant is preparing your food',
        'icon': Icons.restaurant,
      },
      {
        'title': 'Out for Delivery',
        'subtitle': 'Your order is on the way',
        'icon': Icons.delivery_dining,
      },
      {
        'title': 'Delivered',
        'subtitle': 'Enjoy your meal!',
        'icon': Icons.home,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Order #NB10245',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.orange,
                            child: Icon(
                              step['icon'] as IconData,
                              color: Colors.white,
                            ),
                          ),
                          if (index != steps.length - 1)
                            Container(
                              width: 3,
                              height: 65,
                              color: Colors.orange,
                            ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['title'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                step['subtitle'] as String,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RatingScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Rate Your Order',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// RATING & REVIEW
// ============================================================

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating & Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'How was your food?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      size: 40,
                      color: Colors.amber,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Thank you for your review!',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Submit Review',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
