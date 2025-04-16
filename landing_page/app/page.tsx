import Link from "next/link"
import { MousePointer2 } from "lucide-react"
import HeroSection from "@/components/hero-section"
import FeaturesGrid from "@/components/features-grid"
import TestimonialsSection from "@/components/testimonials-section"
import PricingTable from "@/components/pricing-table"
import MouseEffect from "@/components/mouse-effect"
import CompanyLogos from "@/components/company-logos"
import UseCasesSection from "@/components/use-cases-section"

export default function LandingPage() {
  return (
    <div className="flex min-h-screen flex-col bg-black text-white">
      <header className="sticky top-0 z-50 w-full border-b border-white/10 bg-black/80 backdrop-blur-md">
        <div className="container flex h-16 items-center justify-between px-4 md:px-6">
          <Link href="/" className="flex items-center gap-2 font-bold text-xl">
            <MousePointer2 className="h-6 w-6 text-purple-500" />
            <span>INTERVENE</span>
          </Link>
          <nav className="hidden md:flex gap-6">
            <Link href="#features" className="text-sm font-medium text-white/70 transition-colors hover:text-white">
              Features
            </Link>
            <Link href="#use-cases" className="text-sm font-medium text-white/70 transition-colors hover:text-white">
              Use Cases
            </Link>
            <Link href="#testimonials" className="text-sm font-medium text-white/70 transition-colors hover:text-white">
              Testimonials
            </Link>
            <Link href="#pricing" className="text-sm font-medium text-white/70 transition-colors hover:text-white">
              Pricing
            </Link>
          </nav>
          <div className="flex items-center gap-4">
            <Link
              href="#download"
              className="inline-flex h-10 items-center justify-center rounded-md bg-gradient-to-r from-purple-600 to-violet-500 px-6 text-sm font-medium text-white shadow transition-colors hover:bg-gradient-to-r hover:from-purple-700 hover:to-violet-600 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-purple-500"
            >
              Get Started
            </Link>
          </div>
        </div>
      </header>
      <main className="flex-1">
        <HeroSection />
        <CompanyLogos />
        <FeaturesGrid />
        <UseCasesSection />
        <TestimonialsSection />
        <PricingTable />
      </main>
      <footer className="border-t border-white/10 bg-black py-6 md:py-12">
        <div className="container px-4 md:px-6">
          <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-4">
            <div className="space-y-4">
              <Link href="/" className="flex items-center gap-2 font-bold text-xl">
                <MousePointer2 className="h-6 w-6 text-purple-500" />
                <span>INTERVENE</span>
              </Link>
              <p className="text-sm text-white/70">
                Tesla Autopilot for desktops. Built entirely on-device using Meta's Llama Stack for fast, private,
                agentic task execution.
              </p>
            </div>
            <div className="space-y-4">
              <h3 className="text-lg font-medium">Product</h3>
              <ul className="space-y-2 text-sm text-white/70">
                <li>
                  <Link href="#" className="hover:text-white">
                    Features
                  </Link>
                </li>
                <li>
                  <Link href="#" className="hover:text-white">
                    How It Works
                  </Link>
                </li>
                <li>
                  <Link href="#" className="hover:text-white">
                    Security
                  </Link>
                </li>
                <li>
                  <Link href="#" className="hover:text-white">
                    Roadmap
                  </Link>
                </li>
              </ul>
            </div>
            <div className="space-y-4">
              <h3 className="text-lg font-medium">Resources</h3>
              <ul className="space-y-2 text-sm text-white/70">
                <li>
                  <Link href="#" className="hover:text-white">
                    Documentation
                  </Link>
                </li>
                <li>
                  <Link href="#" className="hover:text-white">
                    Guides
                  </Link>
                </li>
                <li>
                  <Link href="#" className="hover:text-white">
                    Blog
                  </Link>
                </li>
                <li>
                  <Link href="#" className="hover:text-white">
                    Support
                  </Link>
                </li>
              </ul>
            </div>
            <div className="space-y-4">
              <h3 className="text-lg font-medium">Company</h3>
              <ul className="space-y-2 text-sm text-white/70">
                <li>
                  <Link href="#" className="hover:text-white">
                    About
                  </Link>
                </li>
                <li>
                  <Link href="#" className="hover:text-white">
                    Careers
                  </Link>
                </li>
                <li>
                  <Link href="#" className="hover:text-white">
                    Privacy
                  </Link>
                </li>
                <li>
                  <Link href="#" className="hover:text-white">
                    Terms
                  </Link>
                </li>
              </ul>
            </div>
          </div>
          <div className="mt-8 border-t border-white/10 pt-8 text-center text-sm text-white/70">
            <p>© {new Date().getFullYear()} Intervene. All rights reserved.</p>
          </div>
        </div>
      </footer>
      <MouseEffect />
    </div>
  )
}
