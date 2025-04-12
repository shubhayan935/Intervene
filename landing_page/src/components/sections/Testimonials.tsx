"use client";

import * as React from "react";

export function Testimonials() {
  return (
    <section className="py-20 md:py-32 bg-background">
      <div className="container mx-auto px-4 md:px-6">
        <div className="text-center mb-12 md:mb-20">
          <h2 className="text-2xl md:text-4xl font-bold mb-6">What customers are saying</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {/* Testimonial 1 */}
          <div className="bg-card/30 border border-border/30 rounded-lg p-8 backdrop-blur-sm relative">
            <div className="mb-6">
              <p className="text-lg leading-relaxed">
                "Intervene is a key tool in our tech stack that everyone gets onboarded to when they join the team. With the peace of mind an organized desktop brings, they can focus on doing what matters most to the business."
              </p>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center">
                <span className="text-primary font-medium text-lg">JB</span>
              </div>
              <div>
                <h4 className="font-medium">Jeff Black</h4>
                <p className="text-sm text-muted-foreground">Head of Engineering</p>
              </div>
            </div>
            <div className="absolute right-8 bottom-8">
              <button className="text-xs text-muted-foreground hover:text-white transition-colors">
                Watch Video
              </button>
            </div>
          </div>

          {/* Testimonial 2 */}
          <div className="bg-card/30 border border-border/30 rounded-lg p-8 backdrop-blur-sm relative">
            <div className="mb-6">
              <p className="text-lg leading-relaxed">
                "It's one thing for me to be better with my workflow, but if my whole team is better, then we tend to make decisions faster, respond faster, and give higher quality outputs to everyone we interact with."
              </p>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center">
                <span className="text-primary font-medium text-lg">SM</span>
              </div>
              <div>
                <h4 className="font-medium">Sarah Miller</h4>
                <p className="text-sm text-muted-foreground">CEO & Co-founder</p>
              </div>
            </div>
            <div className="absolute right-8 bottom-8">
              <button className="text-xs text-muted-foreground hover:text-white transition-colors">
                Watch Video
              </button>
            </div>
          </div>

          {/* Testimonial 3 */}
          <div className="bg-card/30 border border-border/30 rounded-lg p-8 backdrop-blur-sm relative">
            <div className="mb-6">
              <p className="text-lg leading-relaxed">
                "Spending less time on repetitive tasks means I can focus on meaningful work that moves the needle for our business. With Intervene, I have peace of mind that things are taken care of."
              </p>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center">
                <span className="text-primary font-medium text-lg">MK</span>
              </div>
              <div>
                <h4 className="font-medium">Mark Kim</h4>
                <p className="text-sm text-muted-foreground">Head of Growth</p>
              </div>
            </div>
            <div className="absolute right-8 bottom-8">
              <button className="text-xs text-muted-foreground hover:text-white transition-colors">
                Watch Video
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
