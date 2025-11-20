import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_events_test_project/app/core/utils/validators.dart';
import 'package:my_events_test_project/features/auth/presentation/controller/auth_controller.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              
              Text("MyEvents", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  onTap: (index) {
                    controller.isLoginMode.value = (index == 0);
                  },
                  indicator: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[700],
                  dividerColor: Colors.transparent, // Remove underline
                  tabs: const [
                    Tab(text: "Login"),
                    Tab(text: "Sign Up"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. The Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Obx(() => Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            // Email
                            TextFormField(
                              controller: controller.emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: controller.passwordController,
                              obscureText: !controller.showPassword.value,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(controller.showPassword.value ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => controller.showPassword.toggle(),
                                ),
                              ),
                              validator: Validators.validatePassword,
                            ),

                            // Remember Me (Only for Login)
                            if (controller.isLoginMode.value)
                              Row(
                                children: [
                                  Checkbox(
                                    value: controller.rememberMe.value,
                                    onChanged: (v) => controller.rememberMe.value = v!,
                                  ),
                                  const Text('Remember me'),
                                ],
                              ),

                            const SizedBox(height: 24),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value ? null : controller.submit,
                                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                                child: controller.isLoading.value
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                    : Text(controller.isLoginMode.value ? 'Login' : 'Create Account'),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}