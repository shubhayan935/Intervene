import Link from 'next/link';
import { MousePointer2 } from 'lucide-react';
import HeroSection from '@/components/hero-section';
import FeaturesGrid from '@/components/features-grid';
import MouseEffect from '@/components/mouse-effect';
import UseCasesSection from '@/components/use-cases-section';

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
            <Link
              href="#features"
              className="text-sm font-medium text-white/70 transition-colors hover:text-white"
            >
              Features
            </Link>
            <Link
              href="#use-cases"
              className="text-sm font-medium text-white/70 transition-colors hover:text-white"
            >
              Use Cases
            </Link>
            <Link
              href="https://www.youtube.com/watch?v=HxsXosrdD0o"
              target="_blank"
              rel="noopener noreferrer"
              className="text-sm font-medium text-white/70 transition-colors hover:text-white"
            >
              Demo
            </Link>
          </nav>
          <div className="flex items-center gap-4">
            <Link
              href="/intervene.zip"
              download
              className="inline-flex h-10 items-center justify-center rounded-md bg-gradient-to-r from-purple-600 to-violet-500 px-6 text-sm font-medium text-white shadow transition-colors hover:bg-gradient-to-r hover:from-purple-700 hover:to-violet-600 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-purple-500"
            >
              Get Started
            </Link>
          </div>
        </div>
      </header>
      <main className="flex-1">
        <HeroSection />
        <FeaturesGrid />
        <UseCasesSection />
      </main>
      <footer className="border-t border-white/10 bg-black py-6 md:py-12">
        <div className="container flex flex-col items-center justify-center gap-4 px-4 text-center md:px-6">
          <Link
            href="/"
            className="flex items-center gap-2 font-bold text-xl text-white"
          >
            <MousePointer2 className="h-6 w-6 text-purple-500" />
            <span>INTERVENE</span>
          </Link>
          <nav className="flex flex-wrap justify-center gap-6 text-sm text-white/70">
            <Link
              href="#features"
              className="hover:text-white transition-colors"
            >
              Features
            </Link>
            <Link
              href="#use-cases"
              className="hover:text-white transition-colors"
            >
              Use Cases
            </Link>
            <Link
              href="https://www.youtube.com/watch?v=HxsXosrdD0o"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-white transition-colors"
            >
              Demo
            </Link>
            <Link
              href="/intervene.zip"
              download
              className="hover:text-white transition-colors"
            >
              Download
            </Link>
          </nav>
          <p className="text-xs text-white/50 mt-4">
            Built with ❤️ by DG x SS x VSK. <br /> © {new Date().getFullYear()}{' '}
            Intervene. All rights reserved.
          </p>
        </div>
      </footer>

      <MouseEffect />
    </div>
  );
}
