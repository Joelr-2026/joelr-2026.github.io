document.addEventListener(
  "DOMContentLoaded",
  () => {


    /* ========================================================
       01 / SETTINGS
    ======================================================== */

    const reducedMotion =
      window.matchMedia(
        "(prefers-reduced-motion: reduce)"
      ).matches;



    /* ========================================================
       02 / REVEAL ANIMATION
    ======================================================== */

    const revealElements =
      document.querySelectorAll(
        ".reveal"
      );


    if (
      !reducedMotion &&
      "IntersectionObserver" in window
    ) {

      const revealObserver =
        new IntersectionObserver(
          (entries) => {

            entries.forEach(
              (entry) => {

                if (
                  entry.isIntersecting
                ) {

                  entry.target
                    .classList
                    .add(
                      "visible"
                    );


                  revealObserver
                    .unobserve(
                      entry.target
                    );

                }

              }
            );

          },
          {
            threshold: 0.1
          }
        );


      revealElements
        .forEach(
          (element) => {

            revealObserver
              .observe(
                element
              );

          }
        );

    }

    else {

      revealElements
        .forEach(
          (element) => {

            element
              .classList
              .add(
                "visible"
              );

          }
        );

    }



    /* ========================================================
       03 / HERO COUNTERS
    ======================================================== */

    const counters =
      document.querySelectorAll(
        ".counter"
      );


    const animateCounter =
      (counter) => {


        const target =
          Number(
            counter.dataset.target
          );


        if (
          !Number.isFinite(
            target
          )
        ) {

          return;

        }


        if (
          reducedMotion
        ) {

          counter.textContent =
            target;

          return;

        }


        const duration =
          900;


        const startTime =
          performance.now();



        const update =
          (currentTime) => {


            const progress =
              Math.min(
                (
                  currentTime -
                  startTime
                ) /
                duration,
                1
              );


            const eased =
              1 -
              Math.pow(
                1 - progress,
                3
              );


            counter.textContent =
              Math.floor(
                eased *
                target
              );


            if (
              progress < 1
            ) {

              requestAnimationFrame(
                update
              );

            }

            else {

              counter.textContent =
                target;

            }

          };


        requestAnimationFrame(
          update
        );

      };



    if (
      "IntersectionObserver" in window
    ) {

      const counterObserver =
        new IntersectionObserver(
          (entries) => {

            entries.forEach(
              (entry) => {

                if (
                  entry.isIntersecting
                ) {

                  animateCounter(
                    entry.target
                  );


                  counterObserver
                    .unobserve(
                      entry.target
                    );

                }

              }
            );

          },
          {
            threshold: 0.6
          }
        );


      counters
        .forEach(
          (counter) => {

            counterObserver
              .observe(
                counter
              );

          }
        );

    }

    else {

      counters
        .forEach(
          animateCounter
        );

    }



    /* ========================================================
       04 / ACTIVE NAVBAR
    ======================================================== */

    const sections =
      document.querySelectorAll(
        "main section[id]"
      );


    const navLinks =
      document.querySelectorAll(
        ".nav-link"
      );



    const updateActiveNav =
      () => {


        let currentSection =
          "home";


        sections
          .forEach(
            (section) => {


              const sectionTop =
                section.offsetTop -
                180;


              if (
                window.scrollY >=
                sectionTop
              ) {

                currentSection =
                  section.id;

              }

            }
          );


        navLinks
          .forEach(
            (link) => {


              link.classList
                .remove(
                  "active"
                );


              if (
                link.getAttribute(
                  "href"
                ) ===
                `#${currentSection}`
              ) {

                link.classList
                  .add(
                    "active"
                  );

              }

            }
          );

      };


    window.addEventListener(
      "scroll",
      updateActiveNav,
      {
        passive: true
      }
    );


    updateActiveNav();



    /* ========================================================
       05 / SMOOTH INTERNAL LINKS
    ======================================================== */

    const internalLinks =
      document.querySelectorAll(
        'a[href^="#"]'
      );


    internalLinks
      .forEach(
        (link) => {


          link.addEventListener(
            "click",
            (event) => {


              const targetId =
                link.getAttribute(
                  "href"
                );


              if (
                !targetId ||
                targetId === "#"
              ) {

                return;

              }


              const target =
                document.querySelector(
                  targetId
                );


              if (
                !target
              ) {

                return;

              }


              event.preventDefault();


              target
                .scrollIntoView(
                  {

                    behavior:
                      reducedMotion
                        ? "auto"
                        : "smooth",

                    block:
                      "start"

                  }
                );

            }
          );

        }
      );



    /* ========================================================
       06 / PROFILE 3D EFFECT
    ======================================================== */

    const profileStage =
      document.getElementById(
        "profileStage"
      );


    const profileShell =
      document.querySelector(
        ".profile-shell"
      );


    if (
      profileStage &&
      profileShell &&
      !reducedMotion
    ) {


      profileStage
        .addEventListener(
          "mousemove",
          (event) => {


            const rect =
              profileStage
                .getBoundingClientRect();


            const mouseX =
              (
                event.clientX -
                rect.left
              ) /
              rect.width;


            const mouseY =
              (
                event.clientY -
                rect.top
              ) /
              rect.height;


            const rotateY =
              (
                mouseX -
                0.5
              ) *
              4;


            const rotateX =
              (
                0.5 -
                mouseY
              ) *
              4;


            profileShell
              .style
              .transform =
              `
                translate(-50%, -50%)
                perspective(1000px)
                rotateX(${rotateX}deg)
                rotateY(${rotateY}deg)
              `;

          }
        );


      profileStage
        .addEventListener(
          "mouseleave",
          () => {


            profileShell
              .style
              .transform =
              `
                translate(-50%, -50%)
                perspective(1000px)
                rotateX(0deg)
                rotateY(0deg)
              `;

          }
        );

    }



    /* ========================================================
       07 / MOBILE NAVIGATION
    ======================================================== */

    const mobileMenuBtn =
      document.getElementById(
        "mobileMenuBtn"
      );


    const navLinksContainer =
      document.getElementById(
        "navLinks"
      );


    if (
      mobileMenuBtn &&
      navLinksContainer
    ) {


      mobileMenuBtn
        .addEventListener(
          "click",
          () => {


            const isOpen =
              navLinksContainer
                .classList
                .toggle(
                  "open"
                );


            mobileMenuBtn
              .setAttribute(
                "aria-expanded",
                String(
                  isOpen
                )
              );

          }
        );


      navLinks
        .forEach(
          (link) => {


            link.addEventListener(
              "click",
              () => {


                navLinksContainer
                  .classList
                  .remove(
                    "open"
                  );


                mobileMenuBtn
                  .setAttribute(
                    "aria-expanded",
                    "false"
                  );

              }
            );

          }
        );

    }



    /* ========================================================
       08 / COPY EMAIL
    ======================================================== */

    const copyEmailBtn =
      document.getElementById(
        "copyEmailBtn"
      );


    const copyFeedback =
      document.getElementById(
        "copyFeedback"
      );


    if (
      copyEmailBtn
    ) {


      copyEmailBtn
        .addEventListener(
          "click",
          async () => {


            const email =
              copyEmailBtn
                .dataset
                .email;


            try {


              await navigator
                .clipboard
                .writeText(
                  email
                );


              if (
                copyFeedback
              ) {

                copyFeedback
                  .textContent =
                  "Email copied to clipboard.";

              }


            }

            catch (
              error
            ) {


              if (
                copyFeedback
              ) {

                copyFeedback
                  .textContent =
                  email;

              }


            }

          }
        );

    }



    /* ========================================================
       09 / PROJECT CASE STUDY DATA
    ======================================================== */

    const projectData = {


      flagship: {

        title:
          "Flagship End-to-End Analytics",

        summary:
          "A complete business analytics workflow using PostgreSQL, SQL, Python, Pandas and Power BI.",

        goal:
          "Analyze overall sales, revenue, profit, product performance, customer behavior, cities and sales channels, then convert the findings into business insights and recommendations.",

        tools: [
          "PostgreSQL",
          "SQL",
          "Python",
          "Pandas",
          "Power BI"
        ],

        work: [
          "Loaded structured customer, product and order datasets into PostgreSQL.",
          "Performed data validation before business analysis.",
          "Used SQL for sales, profitability, product, customer and channel analysis.",
          "Performed exploratory analysis in Python and Pandas.",
          "Created analytical charts and a Power BI dashboard.",
          "Converted analysis into business insights and recommendations."
        ],

        metrics: [
          [
            "Customers",
            "800"
          ],
          [
            "Products",
            "150"
          ],
          [
            "Orders",
            "3,005"
          ]
        ],

        image:
          "assets/projects/flagship/Images/Flagship_Analytics_Dashboard.png"

      },



      inventory: {

        title:
          "Inventory Optimization & Demand Planning",

        summary:
          "Large-scale SQL and Power BI project focused on demand patterns, validation and planning.",

        goal:
          "Understand demand behavior over time and support inventory planning using historical demand data.",

        tools: [
          "PostgreSQL",
          "SQL",
          "Power BI",
          "DAX"
        ],

        work: [
          "Loaded and validated a large historical demand dataset.",
          "Investigated negative-demand records and missing dates.",
          "Analyzed demand trends across products and other business dimensions.",
          "Created SQL business analysis queries.",
          "Built a Power BI dashboard for demand and planning insights."
        ],

        metrics: [
          [
            "Demand Records",
            "1,048,575"
          ],
          [
            "Negative Demand",
            "10,469"
          ],
          [
            "Missing Dates",
            "11,239"
          ]
        ],

        image:
          "assets/projects/inventory/Images/inventory_dashboard.png"

      },



      churn: {

        title:
          "Customer Churn Analysis",

        summary:
          "Python-based exploratory analysis of customer churn using 1,500 customer records.",

        goal:
          "Identify customer groups and behaviors associated with higher churn and present the findings visually.",

        tools: [
          "Python",
          "Pandas",
          "NumPy",
          "Matplotlib",
          "Seaborn"
        ],

        work: [
          "Inspected dataset structure, data types and missing values.",
          "Cleaned inconsistent category values.",
          "Handled missing city values.",
          "Analyzed churn across contract type, plan, city and signup channel.",
          "Compared behavioral and numeric variables by churn status.",
          "Created charts and documented business insights."
        ],

        metrics: [
          [
            "Customers",
            "1,500"
          ],
          [
            "Churned",
            "396"
          ],
          [
            "Churn Rate",
            "26.4%"
          ]
        ],

        image:
          "assets/projects/churn/Images/churn_by_contract.png"

      },



      ecommerce: {

        title:
          "E-commerce SQL Analysis",

        summary:
          "SQL-focused analytics project demonstrating business analysis from basic querying through advanced SQL.",

        goal:
          "Answer revenue, customer, product, category and trend questions using structured SQL analysis.",

        tools: [
          "PostgreSQL",
          "SQL",
          "CTEs",
          "Window Functions"
        ],

        work: [
          "Created and validated the analysis table.",
          "Used filtering, grouping and aggregations for business questions.",
          "Applied CASE expressions and joins.",
          "Used subqueries and CTEs.",
          "Applied window functions for ranking and advanced analysis.",
          "Analyzed time-based sales performance."
        ],

        metrics: [
          [
            "Records",
            "2,505"
          ],
          [
            "Focus",
            "Business SQL"
          ],
          [
            "Level",
            "Advanced Queries"
          ]
        ],

        image:
          "assets/projects/ecommerce-sql/Images/monthly_sales_trend.png"

      },



      "food-delivery": {

        title:
          "Food Delivery Performance Dashboard",

        summary:
          "Power BI project focused on cleaning, modeling, KPIs and interactive dashboard analysis.",

        goal:
          "Turn food-delivery records into a clear performance dashboard with useful KPIs and interactive filtering.",

        tools: [
          "Power BI",
          "Power Query",
          "DAX"
        ],

        work: [
          "Imported the source dataset into Power BI.",
          "Cleaned and transformed data using Power Query.",
          "Created required calculated measures using DAX.",
          "Built KPI cards and analytical visuals.",
          "Added slicers for interactive exploration.",
          "Created a polished dashboard layout."
        ],

        metrics: [
          [
            "Records",
            "2,000"
          ],
          [
            "Platform",
            "Power BI"
          ],
          [
            "Output",
            "Dashboard"
          ]
        ],

        image:
          "assets/projects/food-delivery/Images/food_delivery_dashboard.png"

      },



      retail: {

        title:
          "Retail Sales Analysis",

        summary:
          "Excel-based retail analytics project covering cleaning, formulas, PivotTables, PivotCharts and dashboarding.",

        goal:
          "Analyze retail sales performance in Excel and present the results through an interactive dashboard.",

        tools: [
          "Excel",
          "Power Query",
          "PivotTables",
          "PivotCharts"
        ],

        work: [
          "Cleaned and prepared the retail dataset.",
          "Used formulas where required for analysis.",
          "Created KPI summaries.",
          "Built PivotTables for business analysis.",
          "Created PivotCharts and slicers.",
          "Designed the final Excel dashboard."
        ],

        metrics: [
          [
            "Records",
            "1,205"
          ],
          [
            "Platform",
            "Excel"
          ],
          [
            "Output",
            "Interactive Dashboard"
          ]
        ],

        image:
          "assets/projects/retail-sales/Images/retail_sales_dashboard.png"

      }


    };



    /* ========================================================
       10 / PROJECT MODAL ELEMENTS
    ======================================================== */

    const modal =
      document.getElementById(
        "caseStudyModal"
      );


    const modalCloseBtn =
      document.getElementById(
        "modalCloseBtn"
      );


    const modalSecondaryClose =
      document.getElementById(
        "modalSecondaryClose"
      );


    const modalImage =
      document.getElementById(
        "modalProjectImage"
      );


    const modalTitle =
      document.getElementById(
        "modalProjectTitle"
      );


    const modalSummary =
      document.getElementById(
        "modalProjectSummary"
      );


    const modalGoal =
      document.getElementById(
        "modalProjectGoal"
      );


    const modalTools =
      document.getElementById(
        "modalProjectTools"
      );


    const modalWork =
      document.getElementById(
        "modalProjectWork"
      );


    const modalMetrics =
      document.getElementById(
        "modalProjectMetrics"
      );


    const caseStudyButtons =
      document.querySelectorAll(
        ".case-study-btn"
      );



    /* ========================================================
       11 / OPEN PROJECT MODAL
    ======================================================== */

    const openModal =
      (projectKey) => {


        const project =
          projectData[
            projectKey
          ];


        if (
          !project ||
          !modal
        ) {

          return;

        }


        modalTitle.textContent =
          project.title;


        modalSummary.textContent =
          project.summary;


        modalGoal.textContent =
          project.goal;


        modalImage.src =
          project.image;


        modalImage.alt =
          `${project.title} preview`;



        /* TOOLS */

        modalTools.innerHTML =
          "";


        project.tools
          .forEach(
            (tool) => {


              const span =
                document
                  .createElement(
                    "span"
                  );


              span.textContent =
                tool;


              modalTools
                .appendChild(
                  span
                );

            }
          );



        /* WORK */

        modalWork.innerHTML =
          "";


        project.work
          .forEach(
            (item) => {


              const li =
                document
                  .createElement(
                    "li"
                  );


              li.textContent =
                item;


              modalWork
                .appendChild(
                  li
                );

            }
          );



        /* METRICS */

        modalMetrics.innerHTML =
          "";


        project.metrics
          .forEach(
            ([label, value]) => {


              const metric =
                document
                  .createElement(
                    "div"
                  );


              metric.className =
                "modal-metric";


              metric.innerHTML =
                `
                  <span>${label}</span>
                  <strong>${value}</strong>
                `;


              modalMetrics
                .appendChild(
                  metric
                );

            }
          );



        modal.classList
          .add(
            "open"
          );


        modal.setAttribute(
          "aria-hidden",
          "false"
        );


        document.body
          .classList
          .add(
            "modal-open"
          );


        if (
          modalCloseBtn
        ) {

          modalCloseBtn
            .focus();

        }

      };



    /* ========================================================
       12 / CLOSE PROJECT MODAL
    ======================================================== */

    const closeModal =
      () => {


        if (
          !modal
        ) {

          return;

        }


        modal.classList
          .remove(
            "open"
          );


        modal.setAttribute(
          "aria-hidden",
          "true"
        );


        document.body
          .classList
          .remove(
            "modal-open"
          );

      };



    caseStudyButtons
      .forEach(
        (button) => {


          button
            .addEventListener(
              "click",
              () => {


                openModal(
                  button
                    .dataset
                    .project
                );

              }
            );

        }
      );



    if (
      modalCloseBtn
    ) {

      modalCloseBtn
        .addEventListener(
          "click",
          closeModal
        );

    }



    if (
      modalSecondaryClose
    ) {

      modalSecondaryClose
        .addEventListener(
          "click",
          closeModal
        );

    }



    if (
      modal
    ) {


      modal
        .addEventListener(
          "click",
          (event) => {


            if (
              event.target ===
              modal
            ) {

              closeModal();

            }

          }
        );

    }



    document
      .addEventListener(
        "keydown",
        (event) => {


          if (
            event.key ===
            "Escape" &&
            modal &&
            modal.classList
              .contains(
                "open"
              )
          ) {

            closeModal();

          }

        }
      );



    /* ========================================================
       13 / CURRENT YEAR
    ======================================================== */

    const currentYear =
      document.getElementById(
        "currentYear"
      );


    if (
      currentYear
    ) {

      currentYear.textContent =
        new Date()
          .getFullYear();

    }


  }
);