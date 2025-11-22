import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_events_test_project/app/core/utils/validators.dart';
import 'package:my_events_test_project/features/auth/presentation/controller/auth_controller.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final theme = Theme.of(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.primaryColor.withOpacity(0.05),
              theme.primaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(w * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.dividerColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.event_available_rounded,
                      size: 60,
                      color: theme.dividerColor.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Text(
                    "Welcome to MyEvents",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Discover and manage amazing events",
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  
                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Obx(() => Row(
                            children: [
                              _buildTabButton(
                                context, 
                                "Login", 
                                controller.isLoginMode.value, 
                                () => controller.toggleMode(true)
                              ),
                              _buildTabButton(
                                context, 
                                "Sign Up", 
                                !controller.isLoginMode.value, 
                                () => controller.toggleMode(false)
                              ),
                            ],
                          )),
                        ),

                        const SizedBox(height: 30),

                        Obx(() => Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                context,
                                controller: controller.emailController,
                                label: 'Email Address',
                                icon: Icons.email_outlined,
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                context,
                                controller: controller.passwordController,
                                label: 'Password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                showPassword: controller.showPassword.value,
                                onTogglePassword: () => controller.showPassword.toggle(),
                                validator: Validators.validatePassword,
                              ),

                              if (controller.isLoginMode.value) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        value: controller.rememberMe.value,
                                        onChanged: (v) => controller.rememberMe.value = v!,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        activeColor: theme.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text("Remember me", style: theme.textTheme.bodyMedium),
                                    const Spacer(),
                                  ],
                                ),
                              ],

                              const SizedBox(height: 30),

                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [theme.primaryColor, theme.primaryColor.withBlue(255)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.primaryColor.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value ? null : controller.submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: controller.isLoading.value
                                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : Text(
                                          controller.isLoginMode.value ? 'Login' : 'Create Account',
                                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
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

  Widget _buildTabButton(BuildContext context, String text, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected 
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] 
              : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ?Colors.grey: theme.dividerColor.withOpacity(0.5) ,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? onTogglePassword,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !showPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.dividerColor.withOpacity(0.3)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                onPressed: onTogglePassword,
              )
            : null,
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}